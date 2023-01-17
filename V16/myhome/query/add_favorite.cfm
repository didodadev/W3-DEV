<cfsetting showdebugoutput="no">
<cfif isDefined("attributes.del")><!--- favori silme --->
    <script>
        elementId = '<cfoutput>#attributes.del#</cfoutput>';
            $.ajax({ url :'WMO/utility.cfc?method=delFavorite', data : {elementId : elementId}, async:false,success : function(res){
                    $("section.favoriteBar ul li[value='"+elementId+"']").remove();
                    if (typeof(Storage) != "undefined") {//browser'ın storage özelliği var mı diye kontrol ediyor.(Check browser support)
                        var local_favlist = $("section.favoriteBar ul").html();
                        localStorage.setItem("favoriteBar_<cfoutput>#session.ep.userid#</cfoutput>", local_favlist);//local storage'e html'i yüklüyor.
                        if(local_favlist == ""){
							$("section.favoriteBar").addClass('hide');//eğer local fav list'in içerisi boşsa favori alanını gizler.
						}
                    }
                    $("div[value='"+elementId+"'] span").removeAttr('onclick').attr('onclick','saveFav("'+elementId+'","<cfoutput>#session.ep.userid#</cfoutput>")');
                    $("div[value='"+elementId+"'] i").removeClass().addClass('icon-pluss');
                    data = $.parseJSON( res );
                    if(!data['DATA'].length)
                        $("section.favoriteBar").addClass('hide');
                }
            });
    </script>
	<cfquery name="FAVO" datasource="#DSN#">
		DELETE 
		FROM 
			FAVORITES
		WHERE
			FAVORITE_ID = #attributes.del#
    </cfquery>
<cfelseif isDefined("attributes.upd")><!--- favori guncelleme --->
	<cfquery name="FAVO" datasource="#DSN#">
		UPDATE FAVORITES SET
			FAVORITE_NAME='#attributes.FAVORITE_NAME#',
			FAVORITE_SHORTCUT_KEY='#attributes.FAVORITE_SHORTCUT_KEY#',
		    IS_NEW_PAGE = #attributes.IS_NEW_PAGE#
		WHERE
			FAVORITE_ID=#attributes.UPD#
	</cfquery>
<cfelse><!--- favori ekleme --->		
    <cfquery name="FAVO" datasource="#DSN#">
        INSERT INTO 
            FAVORITES
                (
                FAVORITE_NAME,
                FAVORITE,
                FAVORITE_SHORTCUT_KEY,
                IS_NEW_PAGE,
                EMP_ID
                )
            VALUES
                (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FAVORITE_NAME#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.connection_way#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FAVORITE_SHORTCUT_KEY#">,
                <cfif isDefined("attributes.IS_NEW_PAGE_") and Len(attributes.IS_NEW_PAGE_)><cfqueryparam cfsqltype = "cf_sql_bit" value = "#attributes.IS_NEW_PAGE_#"><cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                )
    </cfquery>
    <script type="text/javascript">
        location.href = document.referrer;
    </script>
</cfif>

