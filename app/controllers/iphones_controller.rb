class IphonesController < ApplicationController
require 'nokogiri' 
require 'open-uri'
	
	def create
		if Iphone.count != 0 then Iphone.destroy_all end
		@iphone = Iphone.new(params[:iphone])

		regex2 = /\s+/

		page_url = "http://xyo.net/iphone-games/?country=US"
		page = Nokogiri::HTML(open(page_url))

		@iphone.rank = 1
		@iphone.title = page.css("div.titleCont h2")[0].text.gsub(regex2,' ')
		@iphone.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[0].text.gsub(regex2,' ')
		@iphone.price = page.css("div.appInfoCont strong.price")[0].text.gsub(regex2,' ')

		array = ""

		for i in 0..3 do
		if i != 2 
		array = array + page.css("div.screenshot ul.sentiments li")[i].text.strip + "; "
		end
		end
		@iphone.comments = array
		@iphone.save
		counter = 12

		for i in 3..11 do
			@iphone = Iphone.new(params[:iphone])

		@iphone.rank = i-1
		@iphone.title = page.css("div.titleCont h2")[i].text.gsub(regex2,' ')
		@iphone.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[i].text.gsub(regex2,' ')
		@iphone.price = page.css("div.appInfoCont strong.price")[i].text.gsub(regex2,' ')
		
		array = ""
		array = array + page.css("div.screenshot ul.sentiments li")[counter].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+1].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+3].text.strip

		@iphone.comments = array
		counter = counter + 4
		@iphone.save

		@iphone = Iphone.all
		end
	end

	def show
		@iphone = Iphone.find(params[:id])
	end

	def index
		@iphone = Iphone.all
	end
end