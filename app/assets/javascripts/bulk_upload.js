// Bulk Upload JavaScript
// Handles drag-and-drop, IPTC metadata extraction, reordering, and sequential uploads

(function() {
  'use strict';

  var photos = [];
  var uploadInProgress = false;

  // DOM Elements (initialized in init())
  var dropZone, fileInput, previewArea, photoList, gallerySelect;
  var startUploadBtn, clearAllBtn, uploadProgress, progressBar, progressText;
  var uploadResults, resultsSummary, resultsDetails;

  // Initialize drag and drop
  function initDragDrop() {
    dropZone.addEventListener('click', function() {
      fileInput.click();
    });

    fileInput.addEventListener('change', function(e) {
      handleFiles(e.target.files);
    });

    dropZone.addEventListener('dragover', function(e) {
      e.preventDefault();
      e.stopPropagation();
      dropZone.classList.add('drag-over');
    });

    dropZone.addEventListener('dragleave', function(e) {
      e.preventDefault();
      e.stopPropagation();
      dropZone.classList.remove('drag-over');
    });

    dropZone.addEventListener('drop', function(e) {
      e.preventDefault();
      e.stopPropagation();
      dropZone.classList.remove('drag-over');
      handleFiles(e.dataTransfer.files);
    });
  }

  // Handle dropped/selected files
  function handleFiles(files) {
    var imageFiles = Array.from(files).filter(function(file) {
      return file.type.match(/^image\/(jpeg|png|gif)$/);
    });

    if (imageFiles.length === 0) {
      alert('Please select valid image files (JPEG, PNG, or GIF)');
      return;
    }

    imageFiles.forEach(function(file, index) {
      var photoData = {
        id: Date.now() + '-' + index + '-' + Math.random().toString(36).substr(2, 9),
        file: file,
        title: '',
        caption: '',
        byline: '',
        thumbnailUrl: null,
        status: 'pending', // pending, uploading, success, failed
        retryCount: 0
      };

      // Create thumbnail preview
      createThumbnail(photoData);
      
      // Extract IPTC metadata
      extractIPTC(photoData);

      photos.push(photoData);
    });

    updatePreview();
  }

  // Create thumbnail from file
  function createThumbnail(photoData) {
    var reader = new FileReader();
    reader.onload = function(e) {
      photoData.thumbnailUrl = e.target.result;
      updatePhotoItem(photoData);
    };
    reader.readAsDataURL(photoData.file);
  }

  // Extract IPTC metadata from image
  // IPTC data is embedded in JPEG files - we need to parse the binary data
  function extractIPTC(photoData) {
    var reader = new FileReader();
    reader.onload = function(e) {
      var arrayBuffer = e.target.result;
      var iptcData = parseIPTC(arrayBuffer);
      
      if (iptcData) {
        // if (iptcData.title) photoData.title = iptcData.title;
        photoData.title = '';
        if (iptcData.caption) photoData.caption = iptcData.title;
        if (iptcData.byline) photoData.byline = iptcData.caption;
      }

      // Fallback to filename if no title
      // if (!photoData.title) {
      //   photoData.title = photoData.file.name.replace(/\.[^/.]+$/, '').replace(/[-_]/g, ' ');
      // }

      updatePhotoItem(photoData);
    };
    reader.readAsArrayBuffer(photoData.file);
  }

  // Parse IPTC data from ArrayBuffer
  // IPTC-IIM is stored in APP13 marker (0xFFED) in JPEG files
  function parseIPTC(arrayBuffer) {
    var dataView = new DataView(arrayBuffer);
    var offset = 2; // Skip SOI marker
    var length = dataView.byteLength;
    var iptcData = {};

    try {
      while (offset < length) {
        if (dataView.getUint8(offset) !== 0xFF) break;
        
        var marker = dataView.getUint8(offset + 1);
        
        // APP13 marker contains IPTC data
        if (marker === 0xED) {
          var segmentLength = dataView.getUint16(offset + 2);
          var segmentData = new Uint8Array(arrayBuffer, offset + 4, segmentLength - 2);
          
          // Look for Photoshop 3.0 header
          var photoshopHeader = 'Photoshop 3.0';
          var headerFound = false;
          for (var i = 0; i < segmentData.length - photoshopHeader.length; i++) {
            var match = true;
            for (var j = 0; j < photoshopHeader.length; j++) {
              if (segmentData[i + j] !== photoshopHeader.charCodeAt(j)) {
                match = false;
                break;
              }
            }
            if (match) {
              headerFound = true;
              iptcData = parseIPTCSegment(segmentData, i + photoshopHeader.length + 1);
              break;
            }
          }
          break;
        }
        
        // Skip to next marker
        if (marker === 0xD8 || marker === 0xD9) {
          offset += 2;
        } else {
          var segLen = dataView.getUint16(offset + 2);
          offset += 2 + segLen;
        }
      }
    } catch (e) {
      console.log('IPTC parsing error:', e);
    }

    return iptcData;
  }

  // Parse IPTC segment data
  function parseIPTCSegment(data, startOffset) {
    var result = {};
    var offset = startOffset;

    try {
      while (offset < data.length - 5) {
        // Look for 8BIM resource block
        if (data[offset] === 0x38 && data[offset + 1] === 0x42 && 
            data[offset + 2] === 0x49 && data[offset + 3] === 0x4D) {
          
          var resourceId = (data[offset + 4] << 8) | data[offset + 5];
          
          // IPTC-NAA record (resource ID 0x0404)
          if (resourceId === 0x0404) {
            // Skip resource header
            var nameLen = data[offset + 6];
            var paddedNameLen = nameLen + (nameLen % 2 === 0 ? 2 : 1);
            var resourceSize = (data[offset + 6 + paddedNameLen] << 24) | 
                              (data[offset + 7 + paddedNameLen] << 16) | 
                              (data[offset + 8 + paddedNameLen] << 8) | 
                              data[offset + 9 + paddedNameLen];
            
            var iptcStart = offset + 10 + paddedNameLen;
            result = parseIPTCRecords(data, iptcStart, resourceSize);
            break;
          }
          
          offset += 12;
        } else {
          offset++;
        }
      }
    } catch (e) {
      console.log('IPTC segment parsing error:', e);
    }

    return result;
  }

  // Parse individual IPTC records
  function parseIPTCRecords(data, start, length) {
    var result = {};
    var offset = start;
    var end = start + length;
    var textDecoder = new TextDecoder('utf-8');

    try {
      while (offset < end - 5) {
        // IPTC tag marker
        if (data[offset] === 0x1C) {
          var recordType = data[offset + 1];
          var datasetTag = data[offset + 2];
          var dataLength = (data[offset + 3] << 8) | data[offset + 4];
          
          if (recordType === 2) { // Application Record
            // Use TextDecoder to properly handle UTF-8 encoded text
            var bytes = data.slice(offset + 5, offset + 5 + dataLength);
            var value = textDecoder.decode(bytes);
            
            // IPTC tags we care about:
            // 5 = Object Name (Title)
            // 120 = Caption/Abstract (Description)
            // 80 = By-line (Author)
            switch (datasetTag) {
              case 5:   // Object Name / Title
                result.title = value;
                break;
              case 120: // Caption/Abstract / Description
                result.caption = value;
                break;
              case 80:  // By-line
                result.byline = value;
                break;
            }
          }
          
          offset += 5 + dataLength;
        } else {
          offset++;
        }
      }
    } catch (e) {
      console.log('IPTC records parsing error:', e);
    }

    return result;
  }

  // Update the preview area
  function updatePreview() {
    if (photos.length === 0) {
      previewArea.style.display = 'none';
      return;
    }

    previewArea.style.display = 'block';
    photoList.innerHTML = '';

    photos.forEach(function(photo, index) {
      var li = createPhotoListItem(photo, index);
      photoList.appendChild(li);
    });

    // Make list sortable with jQuery UI
    if (typeof jQuery !== 'undefined' && jQuery.fn.sortable) {
      jQuery(photoList).sortable({
        handle: '.drag-handle',
        update: function(event, ui) {
          reorderPhotos();
        }
      });
    }

    updateUploadButton();
  }

  // Create a photo list item
  function createPhotoListItem(photo, index) {
    var li = document.createElement('li');
    li.className = 'photo-item status-' + photo.status;
    li.dataset.photoId = photo.id;

    li.innerHTML = 
      '<div class="drag-handle">☰</div>' +
      '<div class="photo-thumbnail">' +
        (photo.thumbnailUrl ? '<img src="' + photo.thumbnailUrl + '" alt="Preview">' : '<span class="loading">Loading...</span>') +
      '</div>' +
      '<div class="photo-metadata">' +
        '<div class="field-group">' +
          '<label>Title:</label>' +
          '<input type="text" class="photo-title" value="' + escapeHtml(photo.title) + '" placeholder="Enter title">' +
        '</div>' +
        '<div class="field-group">' +
          '<label>Caption:</label>' +
          '<textarea class="photo-caption" placeholder="Enter caption">' + escapeHtml(photo.caption) + '</textarea>' +
        '</div>' +
        '<div class="field-group">' +
          '<label>Byline:</label>' +
          '<input type="text" class="photo-byline" value="' + escapeHtml(photo.byline) + '" placeholder="Enter byline">' +
        '</div>' +
      '</div>' +
      '<div class="photo-status">' +
        '<span class="status-badge">' + getStatusLabel(photo.status) + '</span>' +
        '<button type="button" class="btn-remove" title="Remove">✕</button>' +
      '</div>';

    // Event listeners for input changes
    var titleInput = li.querySelector('.photo-title');
    var captionInput = li.querySelector('.photo-caption');
    var bylineInput = li.querySelector('.photo-byline');
    var removeBtn = li.querySelector('.btn-remove');

    titleInput.addEventListener('input', function() {
      photo.title = this.value;
    });

    captionInput.addEventListener('input', function() {
      photo.caption = this.value;
    });

    bylineInput.addEventListener('input', function() {
      photo.byline = this.value;
    });

    removeBtn.addEventListener('click', function() {
      removePhoto(photo.id);
    });

    return li;
  }

  // Update a single photo item
  function updatePhotoItem(photoData) {
    var li = photoList.querySelector('[data-photo-id="' + photoData.id + '"]');
    if (!li) return;

    // Update thumbnail
    var thumbnailDiv = li.querySelector('.photo-thumbnail');
    if (photoData.thumbnailUrl) {
      thumbnailDiv.innerHTML = '<img src="' + photoData.thumbnailUrl + '" alt="Preview">';
    }

    // Update form fields
    li.querySelector('.photo-title').value = photoData.title;
    li.querySelector('.photo-caption').value = photoData.caption;
    li.querySelector('.photo-byline').value = photoData.byline;

    // Update status
    li.className = 'photo-item status-' + photoData.status;
    li.querySelector('.status-badge').textContent = getStatusLabel(photoData.status);
  }

  // Get status label
  function getStatusLabel(status) {
    switch (status) {
      case 'pending': return 'Pending';
      case 'uploading': return 'Uploading...';
      case 'success': return '✓ Uploaded';
      case 'failed': return '✕ Failed';
      default: return status;
    }
  }

  // Escape HTML
  function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;')
              .replace(/'/g, '&#039;');
  }

  // Remove a photo
  function removePhoto(photoId) {
    photos = photos.filter(function(p) { return p.id !== photoId; });
    updatePreview();
  }

  // Reorder photos after drag
  function reorderPhotos() {
    var newOrder = [];
    var items = photoList.querySelectorAll('.photo-item');
    items.forEach(function(item) {
      var photoId = item.dataset.photoId;
      var photo = photos.find(function(p) { return p.id === photoId; });
      if (photo) newOrder.push(photo);
    });
    photos = newOrder;
  }

  // Update upload button state
  function updateUploadButton() {
    var hasGallery = gallerySelect.value !== '';
    var hasPhotos = photos.length > 0;
    var hasPending = photos.some(function(p) { return p.status === 'pending'; });
    
    startUploadBtn.disabled = !hasGallery || !hasPhotos || !hasPending || uploadInProgress;
  }

  // Clear all photos
  function clearAll() {
    if (uploadInProgress) {
      alert('Cannot clear while upload is in progress');
      return;
    }
    photos = [];
    updatePreview();
    uploadProgress.style.display = 'none';
    uploadResults.style.display = 'none';
  }

  // Start upload process
  function startUpload() {
    if (uploadInProgress) return;
    
    var galleryId = gallerySelect.value;
    if (!galleryId) {
      alert('Please select a gallery');
      return;
    }

    var selectedOption = gallerySelect.options[gallerySelect.selectedIndex];
    var uploadUrl = selectedOption.dataset.uploadUrl;
    
    if (!uploadUrl) {
      alert('Invalid gallery selected');
      return;
    }

    uploadInProgress = true;
    startUploadBtn.disabled = true;
    uploadProgress.style.display = 'block';
    uploadResults.style.display = 'none';

    uploadSequentially(uploadUrl, 0);
  }

  // Upload photos one at a time
  function uploadSequentially(uploadUrl, index) {
    // Find next pending photo
    while (index < photos.length && photos[index].status !== 'pending') {
      index++;
    }

    if (index >= photos.length) {
      // All done
      uploadComplete();
      return;
    }

    var photo = photos[index];
    photo.status = 'uploading';
    updatePhotoItem(photo);
    updateProgress();

    uploadPhoto(uploadUrl, photo, function(success) {
      if (success) {
        photo.status = 'success';
      } else if (photo.retryCount < 1) {
        // Retry once
        photo.retryCount++;
        photo.status = 'uploading';
        uploadPhoto(uploadUrl, photo, function(retrySuccess) {
          photo.status = retrySuccess ? 'success' : 'failed';
          updatePhotoItem(photo);
          uploadSequentially(uploadUrl, index + 1);
        });
        return;
      } else {
        photo.status = 'failed';
      }

      updatePhotoItem(photo);
      uploadSequentially(uploadUrl, index + 1);
    });
  }

  // Upload a single photo
  function uploadPhoto(uploadUrl, photo, callback) {
    var formData = new FormData();
    formData.append('photo[photo]', photo.file);
    formData.append('photo[title]', photo.title);
    formData.append('photo[caption]', photo.caption);
    formData.append('photo[byline]', photo.byline);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', uploadUrl, true);
    xhr.setRequestHeader('X-CSRF-Token', window.csrfToken);
    xhr.setRequestHeader('Accept', 'application/json');

    xhr.onload = function() {
      if (xhr.status >= 200 && xhr.status < 300) {
        try {
          var response = JSON.parse(xhr.responseText);
          callback(response.success);
        } catch (e) {
          callback(false);
        }
      } else {
        callback(false);
      }
    };

    xhr.onerror = function() {
      callback(false);
    };

    xhr.send(formData);
  }

  // Update progress bar
  function updateProgress() {
    var completed = photos.filter(function(p) { 
      return p.status === 'success' || p.status === 'failed'; 
    }).length;
    var total = photos.length;
    var percent = total > 0 ? (completed / total * 100) : 0;

    progressBar.style.width = percent + '%';
    progressText.textContent = completed + ' of ' + total + ' complete';
  }

  // Upload complete
  function uploadComplete() {
    uploadInProgress = false;
    updateProgress();

    var successful = photos.filter(function(p) { return p.status === 'success'; }).length;
    var failed = photos.filter(function(p) { return p.status === 'failed'; }).length;

    uploadResults.style.display = 'block';
    resultsSummary.textContent = successful + ' photos uploaded successfully' + 
                                 (failed > 0 ? ', ' + failed + ' failed' : '');

    // Show details for failed uploads
    if (failed > 0) {
      var failedPhotos = photos.filter(function(p) { return p.status === 'failed'; });
      resultsDetails.innerHTML = '<h3>Failed uploads:</h3><ul>' +
        failedPhotos.map(function(p) { 
          return '<li>' + escapeHtml(p.title || p.file.name) + '</li>'; 
        }).join('') + '</ul>';
    } else {
      resultsDetails.innerHTML = '';
    }

    updateUploadButton();
  }

  // Initialize
  function init() {
    // Get DOM elements (must happen after DOM is ready)
    dropZone = document.getElementById('drop-zone');
    
    // Only run on bulk upload page
    if (!dropZone) return;
    
    fileInput = document.getElementById('file-input');
    previewArea = document.getElementById('preview-area');
    photoList = document.getElementById('photo-list');
    gallerySelect = document.getElementById('gallery-select');
    startUploadBtn = document.getElementById('start-upload');
    clearAllBtn = document.getElementById('clear-all');
    uploadProgress = document.getElementById('upload-progress');
    progressBar = document.getElementById('progress-bar');
    progressText = document.getElementById('progress-text');
    uploadResults = document.getElementById('upload-results');
    resultsSummary = document.getElementById('results-summary');
    resultsDetails = document.getElementById('results-details');

    initDragDrop();

    gallerySelect.addEventListener('change', updateUploadButton);
    startUploadBtn.addEventListener('click', startUpload);
    clearAllBtn.addEventListener('click', clearAll);
  }

  // Run on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
