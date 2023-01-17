<!---
	Dışardan alınan parametreler:
		1. DocumentInfo structure'ı
			DocumentId
			RatingCount
			Rating
			Views
--->
<cf_box title="Oy">
<cfif not isdefined("get_asset")>
	<cfif not isdefined("photoData")>
		<cfset photoData=createObject("component","objects2.asset.query.AssetData").init(dsn,1) />
	</cfif>
	<cfset get_asset = photoData.getAsset(attributes.get_asset) />
</cfif>
<cffunction name="UserLoggedIn" returntype="boolean">
	<cfreturn (isdefined("session.ww.userid") or isdefined("session.pp.userid") or isdefined("session.ep.userid")) />
</cffunction>
<script type="text/javascript">
	var ratingCmp;
	function ratingChange(cmp) {
		myRatingSubmit(document.forms["ratingForm"]);
		ratingCmp = cmp;
	}
	var activePanel="";
	function ShowHideSharePanel() {
		if (activePanel == "") {
			document.getElementById("Panel").style.display="block";
			ajaxpage("index.cfm?fuseaction=myportal.welcome", "Panel");
			activePanel = "share";
		} else {
			document.getElementById("Panel").style.display="none";
			activePanel = "";
		}
	}
	var ajaxConn;
	function myRatingResult() {
		if (ajaxConn.readyState==4 && ajaxConn.status == 200)
		{
			var sonuc = ajaxConn.responseText.split(";");
			ratingCmp.setStars(sonuc[0],true);
	
			document.getElementById("rating_count").innerHTML = sonuc[1];
			document.getElementById("rating_message").innerHTML = "";
		}
	}
	function myRatingSubmit(form) {
		ajaxConn = GetAjaxConnector();
		//alert(form.action);
		AjaxRequest(ajaxConn, form.action, form.method, GetFormData(form), myRatingResult);
		return false;
	}
</script>
<div id="Panel" style="display:none;"></div>
    <div id="photooptions" class="myportal_frame" style="padding:5px;width:480px;">
    <form name="ratingForm" action="<cfoutput>#request.self#?fuseaction=#xfa.set_asset_rating#</cfoutput>" method="post">
        <input name="asset_id" id="asset_id" type="hidden" value="<cfoutput>#attributes.asset_id#</cfoutput>" />
        <input name="asset_file_format" id="asset_file_format" type="hidden" value="1" />
        <cfif get_asset.RATING eq ""><cfset rtng = 0 /><cfelse><cfset rtng=Round(get_asset.RATING)/></cfif>
            <div style="float:left; vertical-align:middle">
            <cf_rating name="rating" emptyimage="/images/star_empty_19x20.png" fullimage="/images/star_full_19x20.png" selectedIndex="#rtng#" onChange="ratingChange(this)" readonly="#iif(not UserLoggedIn(),de('true'),de('false'))#" /><br /><span id="rating_message" style="height:20px;">
        <cfif UserLoggedIn()>
        	<cf_get_lang no='174.Oylamak için yıldızlara tıklayın'>.
        <cfelse>
        	<cf_get_lang no='175.Oylamak için'> <a href="?fuseaction=objects2.public_login"><cf_get_lang no ='1135.giriş yapın'></a>.
        </cfif>
        </span>
    </div>
        <div style="float:right">
            <b><cf_get_lang no='176.Toplam Oylama'>:</b> <cfoutput><span id="rating_count">#get_asset.RATING_COUNT#</span>&nbsp;&nbsp;
            <b><cf_get_lang no='170.İzlenme'>:</b> #get_asset.DOWNLOAD_COUNT#</cfoutput>
        </div>
    </form>
</div>
</cf_box>
