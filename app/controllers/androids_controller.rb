class AndroidsController < ApplicationController
require 'nokogiri' 
require 'open-uri'
	
	def create
		if Android.count != 0 then Android.destroy_all end
		@android = Android.new(params[:android])

		regex2 = /\s+/

		page_url = "http://xyo.net/android-games/?country=US"
		page = Nokogiri::HTML(open(page_url))

		@android.rank = 1
		@android.title = page.css("div.titleCont h2")[0].text.gsub(regex2,' ')
		@android.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[0].text.gsub(regex2,' ')
		@android.price = page.css("div.appInfoCont strong.price")[0].text.gsub(regex2,' ')

		array = ""

		for i in 0..3 do
		if i != 2 
		array = array + page.css("div.screenshot ul.sentiments li")[i].text.strip + "; "
		end
		end
		@android.comments = array
		@android.save
		counter = 12

		for i in 3..11 do
			@android = Android.new(params[:android])

		@android.rank = i-1
		@android.title = page.css("div.titleCont h2")[i].text.gsub(regex2,' ')
		@android.downloads = page.css("div.extraInfo.mobile-hide span.downNo")[i].text.gsub(regex2,' ')
		@android.price = page.css("div.appInfoCont strong.price")[i].text.gsub(regex2,' ')
		
		array = ""
		array = array + page.css("div.screenshot ul.sentiments li")[counter].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+1].text.strip + "; "
		array = array + page.css("div.screenshot ul.sentiments li")[counter+3].text.strip

		@android.comments = array
		counter = counter + 4
		@android.save

		@android = Android.all
		end
	end

	def show
		@android = Android.find(params[:id])
	end

	def index
		@android = Android.all
	end
end