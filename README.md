# Appium Lib - Element Attribute Extender
Extends the appium_lib gem page parser helper class to get the full list of element attributes

Reason
------
I needed a better way to identify the elements on a page and easily obtain a webdriver object to control. By extending the attributes and placing these values into an array of hashes I could then easily filter the results based on their attributes to return the elements I wanted and return the objects to use. I also wanted to replicate what the [uiautomatorviewer](https://developer.android.com/training/testing/ui-automator) provided within my framework. 

Prerequisites For this Example
------------------------------
* [Android SDK Installed](https://developer.android.com/studio/)
* [Appium Installed](https://www.npmjs.com/package/appium)
* [Install Appium Console - ARC](https://github.com/appium/ruby_console)
   * or... ```gem install appium_console```

More Info
---------
Check out the awesome work the appium_lib devs did [here](https://github.com/appium/ruby_lib/blob/9dfa0b9c0c3df6f7ec88d578e304ad1fd3704742/lib/appium_lib/android/common/helper.rb) to parse the page source XML. I extended on this class.

Usage Example
-------------
* Start your appium server
* Connect an android device or emulator
* Open a console window and run ```arc```
   * This should launch the app-debug.apk on your android device inside the appium console REPL.
* Execute ```source```
   * Notice the large amount of XML output returns from the view tree hierarchy. This is hard to read and find the elements you want to use. 
* Execute ```page```
   * Notice this method now nicely parses this data and displays the output for you to get the elements you want to interact with. However, the one problem with this is you cannot dynamically filter these results.
* Execute the code below:

```ruby
require_relative 'page_elements_extender.rb'

view = AndroidParser.new

page_elements = view.elements

clickable = page_elements.find_all { |e| e if e[:clickable] and e[:enabled] } #this returns an array of clickable/visible elements

element = clickable.sample #picks random array value

locator = element[:accessibilty_label] || element[:id] #use accessibility label first and then id if available

if locator.nil?
  wd_object = driver.find_element({xpath: "//#{element[:class]}[@bounds='#{element[:bounds]}']"}) #Use class and bounds as last resort...
else
  wd_object = driver.find_element({id: locator})
end

wd_object.click
```
* This is an example of how you can get only the elements which are clickable and enabled, ignoring everything else.
* You can now use this to build your own crawler and iterate through the clickable array elements.




      
      