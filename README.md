IntData
=======

IntData makes a backup of iOS devices and search in


<h2>Description : </h2>

IntData makes a backup of iOS devices and search in.<br />
It use the library, libimobiledevice for create de backup of iPhone, iPad or iPod.<br />
<br />
<h3>Requires : </h3>
<ul>
  <li>libimobiledevice</li>
  <li>Ruby</li>
  <li>SQLite3</li>
</ul>
<br />
<h3>Run :</h3>
If you have to make backup :
<br />
Plug your device on computer with USB cable and run this command.<br />
<pre>
  <code>
    ruby intdata.rb backup DESTINATION_FOLDER
  </code>
</pre>
<br />
If you want search into a folder :
<pre>
<code>
ruby intdata.rb DESTINATION_FOLDER
</code>
</pre>
<br />
<strong>Example :</strong>
<pre>
<code>
ruby intdata.rb Backup_folder
</code>
</pre>
