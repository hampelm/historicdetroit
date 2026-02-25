xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Historic Detroit"
    xml.description "New posts, galleries, and buildings from Historic Detroit"
    xml.link root_url
    xml.language "en"

    @items.each do |item|
      xml.item do
        xml.title item[:title]
        
        # Build description with photo if available
        description_html = ""
        if item[:photo].present?
          photo_url = item[:photo].start_with?('http') ? item[:photo] : "#{request.protocol}#{request.host_with_port}#{item[:photo]}"
          description_html += "<p><img src=\"#{photo_url}\" alt=\"#{item[:title]}\" style=\"max-width: 600px;\"/></p>"
        end
        
        if item[:description].present?
          # For buildings, show only the first paragraph
          if item[:type] == 'building'
            # Parse HTML and extract first paragraph
            doc = Nokogiri::HTML.fragment(item[:description])
            first_paragraph = doc.css('p').first
            
            if first_paragraph
              description_html += first_paragraph.to_html
              description_html += "<p><em><a href=\"#{item[:url]}\">Read more...</a></em></p>"
            else
              # Fallback if no paragraph tags found
              description_html += item[:description]
            end
          else
            # For posts and galleries, show full content
            description_html += item[:description]
          end
        end
        
        xml.description { xml.cdata!(description_html) }
        
        xml.pubDate item[:timestamp].to_s(:rfc822)
        xml.link item[:url]
        xml.guid item[:url], isPermaLink: "true"
        
        # Add category to distinguish item types
        xml.category item[:type].capitalize
      end
    end
  end
end
