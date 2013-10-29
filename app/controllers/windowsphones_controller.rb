class WindowsphonesController < ApplicationController
require 'nokogiri' 
require 'open-uri'
	
	def create
		if Windowsphone.count != 0 then Windowsphone.destroy_all end
		@windowsphone = Windowsphone.new(params[:windowsphone])

		regex2 = /\s+/

		page_url = "http://xyo.net/windows-phone-games/?country=US"
		page = Nokogiri::HTML(open(page_url))

		@windowsphone.rank = 1
		@windowsphone.title = page.css("div.titleCont h2")[0].text.gsub(regex2,' ')
		@windowsphone.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[0].text.gsub(regex2,' ')
		@windowsphone.price = page.css("div.appInfoCont strong.price")[0].text.gsub(regex2,' ')

		array = ""

		for i in 0..3 do
		if i != 2 
		array = array + page.css("div.screenshot ul.sentiments li")[i].text.strip + "; "
		end
		end
		@windowsphone.comments = array
		@windowsphone.save
		counter = 12

		for i in 3..11 do
			@windowsphone = Windowsphone.new(params[:windowsphone])

		@windowsphone.rank = i-1
		@windowsphone.title = page.css("div.titleCont h2")[i].text.gsub(regex2,' ')
		@windowsphone.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[i].text.gsub(regex2,' ')
		@windowsphone.price = page.css("div.appInfoCont strong.price")[i].text.gsub(regex2,' ')
		
		array = ""
		array = array + page.css("div.screenshot ul.sentiments li")[counter].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+1].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+3].text.strip

		@windowsphone.comments = array
		counter = counter + 4
		@windowsphone.save

		@windowsphone = Windowsphone.all
		end
	end

	def show
		@windowsphone = Windowsphone.find(params[:id])
	end

	def index
		@windowsphone = Windowsphone.all
	end
end