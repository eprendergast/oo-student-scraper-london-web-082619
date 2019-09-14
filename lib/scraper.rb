require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    # responsible for scraping the index page that lists all of the students
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    doc.css(".student-card").each do |student|
      student_hash = {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").attribute("href").value,
      }
      students << student_hash
    end
    students
  end

  profile_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html"

  def self.scrape_profile_page(profile_url)
    # responsible for scraping an individual student's profile page to get further information about that student.
    html = open(profile_url)
    profile = Nokogiri::HTML(html)

    scraped_student = {}
    
    social_media = profile.css(".social-icon-container a")
    social_media.each do |a|
      if a.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = a.attribute("href").value
      elsif a.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = a.attribute("href").value
      elsif a.attribute("href").value.include?("github")
        scraped_student[:github] = a.attribute("href").value
      else
        scraped_student[:blog] = a.attribute("href").value
      end
    end

    scraped_student[:profile_quote] = profile.css(".vitals-text-container").css(".profile-quote").text
    scraped_student[:bio] = profile.css(".bio-content.content-holder .description-holder p").text
    scraped_student
  end

end

