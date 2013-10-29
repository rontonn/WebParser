class IpadsController < ApplicationController
require 'nokogiri' 
require 'open-uri'
	
	def create
		if Ipad.count != 0 then Ipad.destroy_all end
		@ipad = Ipad.new(params[:ipad])

		regex2 = /\s+/

		page_url = "http://xyo.net/ipad-games/?country=US"
		page = Nokogiri::HTML(open(page_url))

		@ipad.rank = 1
		@ipad.title = page.css("div.titleCont h2")[0].text.gsub(regex2,' ')
		@ipad.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[0].text.gsub(regex2,' ')
		@ipad.price = page.css("div.appInfoCont strong.price")[0].text.gsub(regex2,' ')

		array = ""

		for i in 0..3 do
		if i != 2 
		array = array + page.css("div.screenshot ul.sentiments li")[i].text.strip + "; "
		end
		end
		@ipad.comments = array
		@ipad.save
		counter = 12

		for i in 3..11 do
			@ipad = Ipad.new(params[:ipad])

		@ipad.rank = i-1
		@ipad.title = page.css("div.titleCont h2")[i].text.gsub(regex2,' ')
		@ipad.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[i].text.gsub(regex2,' ')
		@ipad.price = page.css("div.appInfoCont strong.price")[i].text.gsub(regex2,' ')
		
		array = ""
		array = array + page.css("div.screenshot ul.sentiments li")[counter].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+1].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+3].text.strip

		@ipad.comments = array
		counter = counter + 4
		@ipad.save

		@ipad = Ipad.all
		end
	end

	def show
		@ipad = Ipad.find(params[:id])
	end

	def index
		@ipad =Ipad.all
	end

end