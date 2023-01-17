<cfoutput>
<p>#application.functions.getlang('forum',63)# #NAME# #SURNAME#,</p></br>
<p>#application.functions.getlang('forum',13)#</p>
<p><a href="#siteDomain##request.self#?fuseaction=forum.view_topic&forumid=#arguments.forumid#">#application.functions.getlang('bank',197)#</a></p>
<!---<p>Forum : #arguments.forumname#</p>
<p>#application.functions.getlang('main',68)# : #arguments.topic#</p>--->
<p>#application.functions.getlang('main',1242)# : #arguments.reply#</p>
</br>
<p><strong>Workcube Forum</strong></p>
</cfoutput>