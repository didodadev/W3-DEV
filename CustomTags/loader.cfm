<!---
Description :
    Bu customtag sayfalama işlemlerini scroll ile aşağı indikçe ya da sayfa sonundaki butona tıklandıkça yapmak amacıyla yazılmıştır.
Parameters :
    id                      Daha fazla göster butonu için oluşturulan benzersiz id                
    data_type               Ajax işleminden hangi tipte veri döneceğini belirtmek için kullanılır (HTML) - JSON Eklenecek
    append_element		    required : İşlem sonucunda dönen verinin hangi elementin içerisine yazılacağını belirtmek için kullanılır (elementid)
    href                    required : İçeriğin hangi dosyadan alınacağını belirler. İçeriğin isteneceği url gönderilir  
    totalCount              required : Tablodaki toplam kayıt sayısı
    startrow                Kayıtların hangi satırdan itibaren gösterileceğini belirler
    maxrows                 Loader işleminde kaç kayıt listeleneceğini belirler
    win_scroll              1 ya da 0 alır. İçeriğin scroll aşağı indikçe yüklenmesi isteniyorsa 1, sadece sayfa sonundaki butona tıklanarak yüklenmesi isteniyorsa 0 gönderilir.
Syntax : 
    <cf_loader data_type='' append_element='' href='' totalCount='' startrow='' maxrows='' win_scroll=''>
Created :   UH20190206
 --->
<cfparam name="attributes.id" default="loader_#round(rand()*10000000)#">
<cfparam name="attributes.data_type" type="string" default="HTML">
<cfparam name="attributes.append_element" type="string" default="">
<cfparam name="attributes.href" type="string" default="">
<cfparam name="attributes.totalCount" type="integer" default="0">
<cfparam name="attributes.startrow" type="integer" default="0">
<cfparam name="attributes.maxrows" type="integer" default="0">
<cfparam name="attributes.win_scroll" type="integer" default="1">
<style>
.loading-area{
    text-align:center;
    padding-left:0px !important;
    padding-right:0px !important;
    padding: 15px;
}

    .loading-area .showMoreButton{
        cursor:pointer;
        background-color: #e4e4e4;
        padding: 10px;
        font-size: 16px;
        color: #333;
    }

    .loading-area .pageEnd{
        background-color: #e4e4e4;
        padding: 10px;
        font-size: 16px;
        color: #333;
    }
</style>
<div class="col col-12 loading-area" id="<cfoutput>#attributes.id#</cfoutput>">
    <div class="col col-12 showMoreButton"><cfoutput>#caller.getLang('assetcare',513)#</cfoutput></div>
</div>

<script>
    var totalCount = <cfoutput>#attributes.totalCount#</cfoutput>;
    var startrow = <cfoutput>#attributes.startrow + attributes.maxrows#</cfoutput>;
    var maxrows = <cfoutput>#attributes.maxrows#</cfoutput>;
    function getData(){
        <cfif attributes.win_scroll eq 1>
            oldHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
        </cfif>
        $("#<cfoutput>#attributes.id#</cfoutput>").html('<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>');
        ajaxConn = GetAjaxConnector();
		AjaxRequest(ajaxConn, "<cfoutput>#attributes.href#</cfoutput>&isAjax=1&startrow="+startrow+"&maxrows=<cfoutput>#attributes.maxrows#</cfoutput>", 'GET', '', function(){
            if (ajaxConn.readyState == 4 && ajaxConn.status == 200)
			{
				<cfif attributes.data_type eq "HTML">
                    $("#<cfoutput>#attributes.append_element#</cfoutput>").append(ajaxConn.responseText);
                    $("#<cfoutput>#attributes.id#</cfoutput>").html('<div class="col col-12 showMoreButton"><cfoutput>#caller.getLang("assetcare",513)#</cfoutput></div>');
                    startrow = startrow + maxrows;
                </cfif>
			}
        });
    }
    function getDataBefore(){
        if(totalCount >= startrow) getData();
        else $("#<cfoutput>#attributes.id#</cfoutput>").html('<div class="col col-12 pageEnd"><cfoutput>#caller.getLang("assetcare",492)#</cfoutput></div>');
    }
    $("#<cfoutput>#attributes.id#</cfoutput>").delegate("div.showMoreButton","click",function(){
		getDataBefore();
	});
    <cfif attributes.win_scroll eq 1>
        var oldHeight = 0;
        window.onscroll = function(){
            var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            
            if((winScroll == height) && (oldHeight != height)){
                   getDataBefore();
            }
        }
    </cfif>  
</script>