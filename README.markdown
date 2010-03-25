Hobo-jqGrid
===========

This is a plugin that integrates the jqGrid component with Hobo.

See the [screencast](http://www.screencast.com/t/7nCgbl5L3) showing the install and a few features.
Another [screencast](http://www.screencast.com/t/2cSE9jNvh) showing add edit and search capabilities.


Information on how to use the features of this grid can be found here.

[http://www.trirand.com/jqgrid35/jqgrid.html](http://www.trirand.com/jqgrid35/jqgrid.html)

The grid has a blog:

[http://www.trirand.com/blog](http://www.trirand.com/blog)

Thanks to Tony Tomov the creator of this great component!

Example 
-------

To install

    cd vendor/plugins
    git clone git://github.com/blizz/hobo-jqgrid.git
    cd ..
    cd ..
    rake hobo_jqgrid:install

Add a table to your app named colmodel with this structure:

    fields do
      jqgrid_id :string, :length => 30
      elf       :string, :length => 10
      colmodel  :text    
      timestamps #optional
    end

Edit appliction.dryml and add:

    <include src="jqgrid" plugin="hobo-jqgrid"/>

Add this to scripts portion of your index page:

    <jqgrid-includes/>


In the content section of your index page put:

    <jqgrid id="mygrid"/>


Example:

    <index-page>
      <append-scripts:>
        <jqgrid-includes/>
      </append-scripts:>
      <content-body:>
        <jqgrid id="mygrid"/>
      </content-body:>  
    </index-page>

Copyright (c) 2010 Brett Nelson, released under the MIT license
