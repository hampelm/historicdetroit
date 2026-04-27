// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require cocoon

(function() {
  'use strict';

  // ============================================
  // UTILITY FUNCTIONS
  // ============================================
  
  // Get photo position from URL hash (e.g., #p3 -> 3)
  function getPhotoFromHash() {
    var hash = window.location.hash;
    if (hash && hash.match(/^#p\d+$/)) {
      return parseInt(hash.substring(2), 10);
    }
    return null;
  }

  // Update URL hash without scrolling
  function setPhotoHash(position) {
    if (history.replaceState) {
      history.replaceState(null, null, '#p' + position);
    } else {
      window.location.hash = '#p' + position;
    }
  }

  // ============================================
  // LIGHTBOX (for Collage View)
  // ============================================
  
  var Lightbox = {
    el: null,
    photos: [],
    currentIndex: 0,

    init: function() {
      this.el = document.getElementById('gallery-lightbox');
      if (!this.el) return;

      // Gather all photos
      var photoEls = document.querySelectorAll('.photos-collage .collage-photo');
      this.photos = Array.prototype.map.call(photoEls, function(el) {
        return {
          position: parseInt(el.dataset.photoPosition, 10),
          url: el.dataset.photoUrl,
          caption: el.dataset.photoCaption || '',
          byline: el.dataset.photoByline || ''
        };
      });

      if (this.photos.length === 0) return;

      this.bindEvents();
      this.checkHashOnLoad();
    },

    bindEvents: function() {
      var self = this;

      // Click on collage photo opens lightbox
      document.querySelectorAll('.photos-collage .collage-photo').forEach(function(el) {
        el.addEventListener('click', function() {
          var position = parseInt(el.dataset.photoPosition, 10);
          self.open(position);
        });
      });

      // Close button
      this.el.querySelector('.lightbox-close').addEventListener('click', function() {
        self.close();
      });

      // Backdrop click closes
      this.el.querySelector('.lightbox-backdrop').addEventListener('click', function() {
        self.close();
      });

      // Navigation buttons
      this.el.querySelector('.lightbox-prev').addEventListener('click', function(e) {
        e.stopPropagation();
        self.prev();
      });

      this.el.querySelector('.lightbox-next').addEventListener('click', function(e) {
        e.stopPropagation();
        self.next();
      });

      // Prevent clicks on image container from closing
      this.el.querySelector('.lightbox-image-container').addEventListener('click', function(e) {
        e.stopPropagation();
      });

      // Keyboard navigation
      document.addEventListener('keydown', function(e) {
        if (!self.el.classList.contains('active')) return;

        if (e.key === 'Escape') {
          self.close();
        } else if (e.key === 'ArrowLeft') {
          self.prev();
        } else if (e.key === 'ArrowRight') {
          self.next();
        }
      });
    },

    checkHashOnLoad: function() {
      var position = getPhotoFromHash();
      if (position !== null) {
        this.open(position);
      }
    },

    findIndexByPosition: function(position) {
      for (var i = 0; i < this.photos.length; i++) {
        if (this.photos[i].position === position) {
          return i;
        }
      }
      return 0;
    },

    open: function(position) {
      this.currentIndex = this.findIndexByPosition(position);
      this.render();
      this.el.classList.add('active');
      document.body.style.overflow = 'hidden';
    },

    close: function() {
      this.el.classList.remove('active');
      document.body.style.overflow = '';
      // Clear URL hash
      if (history.replaceState) {
        history.replaceState(null, null, window.location.pathname + window.location.search);
      }
    },

    prev: function() {
      this.currentIndex = (this.currentIndex - 1 + this.photos.length) % this.photos.length;
      this.render();
    },

    next: function() {
      this.currentIndex = (this.currentIndex + 1) % this.photos.length;
      this.render();
    },

    render: function() {
      var photo = this.photos[this.currentIndex];
      this.el.querySelector('.lightbox-image').src = photo.url;
      this.el.querySelector('.lightbox-image').alt = photo.caption;
      this.el.querySelector('.lightbox-caption').textContent = photo.caption;
      this.el.querySelector('.lightbox-byline').textContent = photo.byline;
      setPhotoHash(photo.position);
    }
  };

  // ============================================
  // CAROUSEL
  // ============================================
  
  var Carousel = {
    container: null,
    photos: [],
    currentIndex: 0,

    init: function() {
      this.container = document.querySelector('.photos-carousel');
      if (!this.container) return;

      // Gather all photos from thumbnails
      var thumbEls = this.container.querySelectorAll('.carousel-thumb');
      this.photos = Array.prototype.map.call(thumbEls, function(el) {
        return {
          position: parseInt(el.dataset.photoPosition, 10),
          url: el.dataset.photoUrl,
          caption: el.dataset.photoCaption || '',
          byline: el.dataset.photoByline || ''
        };
      });

      if (this.photos.length === 0) return;

      this.bindEvents();
      this.checkHashOnLoad();
    },

    bindEvents: function() {
      var self = this;

      // Thumbnail clicks
      this.container.querySelectorAll('.carousel-thumb').forEach(function(el, index) {
        el.addEventListener('click', function() {
          self.goTo(index);
        });
      });

      // Navigation buttons
      this.container.querySelector('.carousel-prev').addEventListener('click', function() {
        self.prev();
      });

      this.container.querySelector('.carousel-next').addEventListener('click', function() {
        self.next();
      });

      // Keyboard navigation
      document.addEventListener('keydown', function(e) {
        if (e.key === 'ArrowLeft') {
          self.prev();
        } else if (e.key === 'ArrowRight') {
          self.next();
        }
      });
    },

    checkHashOnLoad: function() {
      var position = getPhotoFromHash();
      if (position !== null) {
        var index = this.findIndexByPosition(position);
        this.goTo(index);
      }
    },

    findIndexByPosition: function(position) {
      for (var i = 0; i < this.photos.length; i++) {
        if (this.photos[i].position === position) {
          return i;
        }
      }
      return 0;
    },

    prev: function() {
      this.goTo((this.currentIndex - 1 + this.photos.length) % this.photos.length);
    },

    next: function() {
      this.goTo((this.currentIndex + 1) % this.photos.length);
    },

    goTo: function(index) {
      this.currentIndex = index;
      var photo = this.photos[index];

      // Update main image
      var mainImg = this.container.querySelector('.carousel-main-image');
      mainImg.src = photo.url;
      mainImg.alt = photo.caption;

      // Update caption
      var captionContainer = this.container.querySelector('.carousel-caption');
      captionContainer.innerHTML = '';
      if (photo.caption) {
        var p = document.createElement('p');
        p.className = 'caption';
        p.textContent = photo.caption;
        captionContainer.appendChild(p);
      }
      if (photo.byline) {
        var byline = document.createElement('p');
        byline.className = 'byline';
        byline.textContent = photo.byline;
        captionContainer.appendChild(byline);
      }

      // Update active thumbnail
      this.container.querySelectorAll('.carousel-thumb').forEach(function(el, i) {
        el.classList.toggle('active', i === index);
      });

      // Scroll thumbnail into view
      var thumbs = this.container.querySelectorAll('.carousel-thumb');
      var activeThumb = thumbs[index];
      if (activeThumb) {
        var scrollContainer = this.container.querySelector('.carousel-thumbnails-scroll');
        var thumbLeft = activeThumb.offsetLeft;
        var thumbWidth = activeThumb.offsetWidth;
        var containerWidth = scrollContainer.offsetWidth;
        var scrollLeft = scrollContainer.scrollLeft;

        // If thumbnail is out of view, scroll to it
        if (thumbLeft < scrollLeft || thumbLeft + thumbWidth > scrollLeft + containerWidth) {
          scrollContainer.scrollLeft = thumbLeft - (containerWidth / 2) + (thumbWidth / 2);
        }
      }

      // Update URL hash
      setPhotoHash(photo.position);
    }
  };

  // ============================================
  // JUSTIFIED GALLERY LAYOUT (for Collage View)
  // ============================================
  
  var JustifiedGallery = {
    container: null,
    photos: [],
    targetHeight: 200,
    gap: 8,

    init: function() {
      this.container = document.querySelector('.photos-collage');
      if (!this.container) return;

      // Get configuration from data attributes
      this.targetHeight = parseInt(this.container.dataset.targetHeight, 10) || 200;
      this.gap = parseInt(this.container.dataset.gap, 10) || 8;

      // Gather photo elements and their aspect ratios
      var photoEls = this.container.querySelectorAll('.collage-photo');
      this.photos = Array.prototype.map.call(photoEls, function(el) {
        return {
          el: el,
          aspectRatio: parseFloat(el.dataset.aspectRatio) || 1.0
        };
      });

      if (this.photos.length === 0) return;

      // Initial layout
      this.layout();

      // Relayout on resize (debounced)
      var self = this;
      var resizeTimeout;
      window.addEventListener('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
          self.layout();
        }, 100);
      });
    },

    layout: function() {
      var containerWidth = this.container.offsetWidth;
      if (containerWidth === 0) return;

      var rows = this.computeRows(containerWidth);
      this.applyLayout(rows);
    },

    computeRows: function(containerWidth) {
      var rows = [];
      var currentRow = [];
      var currentRowWidth = 0;
      var targetHeight = this.targetHeight;
      var gap = this.gap;

      for (var i = 0; i < this.photos.length; i++) {
        var photo = this.photos[i];
        // Width this photo would be at target height
        var photoWidth = targetHeight * photo.aspectRatio;

        currentRow.push(photo);
        currentRowWidth += photoWidth + (currentRow.length > 1 ? gap : 0);

        // Check if row is full
        if (currentRowWidth >= containerWidth) {
          rows.push({
            photos: currentRow.slice(),
            totalAspectRatio: currentRow.reduce(function(sum, p) { return sum + p.aspectRatio; }, 0),
            isComplete: true
          });
          currentRow = [];
          currentRowWidth = 0;
        }
      }

      // Handle last incomplete row
      if (currentRow.length > 0) {
        rows.push({
          photos: currentRow,
          totalAspectRatio: currentRow.reduce(function(sum, p) { return sum + p.aspectRatio; }, 0),
          isComplete: false
        });
      }

      return rows;
    },

    applyLayout: function(rows) {
      var containerWidth = this.container.offsetWidth;
      var gap = this.gap;
      var targetHeight = this.targetHeight;

      for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        var photos = row.photos;
        var numGaps = photos.length - 1;
        var availableWidth = containerWidth - (numGaps * gap);

        // Calculate row height
        // For complete rows: scale to fill the width exactly
        // For incomplete rows: use target height (don't stretch)
        var rowHeight;
        if (row.isComplete) {
          rowHeight = availableWidth / row.totalAspectRatio;
        } else {
          rowHeight = targetHeight;
        }

        // Apply dimensions to each photo
        for (var j = 0; j < photos.length; j++) {
          var photo = photos[j];
          var width = rowHeight * photo.aspectRatio;

          photo.el.style.width = width + 'px';
          photo.el.style.height = rowHeight + 'px';

          var img = photo.el.querySelector('img');
          if (img) {
            img.style.width = '100%';
            img.style.height = '100%';
            img.style.objectFit = 'cover';
          }
        }
      }

      // Mark container as laid out (for CSS transition)
      this.container.classList.add('justified');
    }
  };

  // ============================================
  // VERTICAL VIEW URL HASH
  // ============================================
  
  function initVerticalHash() {
    var vertical = document.querySelector('.photos-vertical');
    if (!vertical) return;

    // Check for hash on load and scroll to photo
    var position = getPhotoFromHash();
    if (position !== null) {
      var photoEl = document.getElementById('p' + position);
      if (photoEl) {
        setTimeout(function() {
          photoEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 100);
      }
    }
  }

  // ============================================
  // INITIALIZATION
  // ============================================
  
  document.addEventListener('DOMContentLoaded', function() {
    var pageEl = document.querySelector('[data-gallery-view]');
    if (!pageEl) return;

    var viewType = pageEl.dataset.galleryView;

    if (viewType === 'collage') {
      JustifiedGallery.init();
      Lightbox.init();
    } else if (viewType === 'carousel') {
      Carousel.init();
    } else if (viewType === 'vertical') {
      initVerticalHash();
    }
  });

})();
