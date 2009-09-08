Hobo-jqGrid
========

This is a plugin that integrates the jqGrid component with Hobo.

See the "screencast":http://www.screencast.com/t/7nCgbl5L3 showing the install and a few features.
Another "screencast":http://www.screencast.com/t/2cSE9jNvh showing add edit and search capabilities.


Information on how to use the features of this grid can be found here.

"http://www.trirand.com/jqgrid35/jqgrid.html":http://www.trirand.com/jqgrid35/jqgrid.html

The grid has a blog:
"http://www.trirand.com/blog":http://www.trirand.com/blog

Thanks to Tony Tomov the creator of this great component!

Example <br/>
=======<br/>

To install<br/>
cd vendor\plugins<br/>
git clone git://github.com/blizz/hobo-jqgrid.git<br/>
cd ..<br/>
cd ..<br/>
rake hobo_jqgrid:install<br/>

Add a table to your app named colmodel with this structure:<br/>
  fields do<br/>
    jqgrid_id :string, :length => 30<br/>
    elf       :string, :length => 10<br/>
    colmodel  :text    <br/>
    timestamps #optional<br/>
  end<br/>
<br/>
Edit appliction.dryml and add:<br/>
&lt;include src="jqgrid" plugin="hobo-jqgrid"/&gt;<br/>

In the header of your index page put:<br/>
&lt;jqgrid-includes/&gt;<br/>

In the content section of your index page put:<br/>
&lt;jqgrid id="mygrid"/&gt;<br/>

More docs to come soon....




Copyright (c) 2009 [name of plugin creator], released under the MIT license
