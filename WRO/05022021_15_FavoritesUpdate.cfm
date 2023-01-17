<!-- Description : Sık kullanılanlarda Favorite kolonu update ediliyor.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE FAVORITES SET FAVORITE = 'index.cfm?fuseaction=' + FAVORITE WHERE FAVORITE NOT LIKE '%index.cfm?fuseaction=%'
</querytag>