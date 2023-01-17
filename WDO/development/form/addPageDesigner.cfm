<cfsetting showdebugoutput="yes">
<cfparam name="attributes.pages" default="">
<cfparam name="attributes.event" default="upd">
<cfset controllerFilePath = listlast(attributes.page,';')>
<cfset newIndexFolder = replace(index_folder,'cfc\','')>

<cffile action="read" file="#newIndexFolder##controllerFilePath#" variable="dosya1" charset="utf-8">
<cfset pageArray = ListToArray(dosya1,Chr(13) & Chr(10))>

<cfset objectLocation = ''>
<cfset pageLocation = ''>
<cfloop index="satir" from="1" to="#arraylen(pageArray)#">
	<cfif pageArray[satir] contains "WOStruct['##attributes.fuseaction##']['pageObjects']">
		<cfset objectLocation = listAppend(objectLocation,pageArray[satir],'||')>
	<cfelseif pageArray[satir] contains "WOStruct['##attributes.fuseaction##']['pageParams']">
    	<cfset pageLocation = listAppend(pageLocation,pageArray[satir],'||')>
    </cfif>
</cfloop>

<cfloop list="#pageLocation#" index="satirlar" delimiters="||">
    <cfif not (satirlar contains 'StructNew' or satirlar contains 'structNew')>
        <cfset PageStyle = Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageParams']['upd']['size']",'')>
        <cfset PageStyle = Replace(PageStyle,'=','')>
        <cfset PageStyle = Replace(PageStyle,'"','','all')>
        <cfset PageStyle = Replace(PageStyle,"'",'','all')>
        <cfset PageStyleLen = len(PageStyle)>
        <cfset PageStyle = left(PageStyle,PageStyleLen-1)>
    </cfif>
</cfloop>

<cf_get_lang_set module_name='member'>
<cfform name="pageDesigner" method="post" action="#request.self#?fuseaction=dev.emptypopup_addPageDesigner">
	<cfoutput>
        <input type="hidden" name="page" id="page" value="#attributes.page#" />
        <input type="hidden" name="event" id="event" value="#attributes.event#" />
        <div class="row">
            <div class="col col-4 text-left">
            	<div class="row">
                	<div class="col col-4 txtbold">Sayfa D�zeni</div>
                	<div class="col col-8"><input type="text" name="pageType" id="pageType" value="#trim(pageStyle)#" onchange="createPage();"/></div>
                </div>
            	<div class="row">
                	<div class="col col-4 txtbold">Obje Adi</div>
                	<div class="col col-2 txtbold">Kolon</div>
                    <div class="col col-2 txtbold">Sira</div>
                    <div class="col col-2 txtbold">G�sterme</div>
                </div>
				<cfset index = 0>
                <cfloop list="#objectLocation#" index="satirlar" delimiters="||">
                    <cfif not (satirlar contains 'StructNew' or satirlar contains 'structNew') and satirlar contains "WOStruct['##attributes.fuseaction##']['pageObjects']['upd']">
                        <cfif satirlar contains "WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']">
                            <cfset index = index + 1>
                            <div class="row" id="row#index#">
                                <div id="screenName#index#" class="col col-4">
                                    <cfif Replace(Replace(listlast(Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']",''),'='),"'",'','all'),';','') contains '##'>
                                        #evaluate("#listFirst(Replace(listlast(Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']",''),'='),"'",'','all'),';')#")#
                                    <cfelse>
                                        #listFirst(Replace(listlast(Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']",''),'='),"'",'','all'),';')#
                                    </cfif>
                                </div>
                                <cfset liste = Replace(Replace(Replace(listFirst(Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']",''),'='),'][',','),'[',''),']','')>
                                <div class="col col-2">
                                    <input class="kolon" type="text" name="kolon#index#" id="kolon#index#" value="#trim(listFirst(liste,','))#" style="width:20px;"/>
                                </div>
                                <div class="col col-2">
                                    <input class="sira" type="text" name="sira#index#" id="sira#index#" value="#trim(listLast(liste,','))#" style="width:20px;" onchange="reloadPage(this);"/>
                                    <cfset 'objectId#index#' =  trim(listGetAt(Replace(listlast(Replace(satirlar,"WOStruct['##attributes.fuseaction##']['pageObjects']['upd']['title']",''),'='),"'",'','all'),2,';'))>
                                    <input class="realPosition" type="hidden" name="realPosition#index#" id="realPosition#index#" value="#trim(liste)#"/>
                                    <input type="hidden" name="objectId#index#" id="objectId#index#" value="#evaluate('objectId#index#')#"/>
                                </div>
                                <div class="col col-2"><input class="showCheckbox" type="checkbox" name="show#index#" id="show#index#" /></div>
                            </div>
                        </cfif>
                    </cfif>
                </cfloop>
				<div class="row">
                    <div class="col col-12"><a href="javascript://" onclick="alert(1);"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></div>
                </div>
				<div class="row">
                    <div class="col col-4"><input name="extraObject" /></div>
                    <div class="col col-2"><input type="text" name="show#index#" id="show#index#" style="width:20px;"/></div>
                    <div class="col col-2"><input type="text" name="show#index#" id="show#index#" style="width:20px;"/></div>
                    <div class="col col-2"><input type="text" name="show#index#" id="show#index#" /></div>
                </div>
                <div class="row buttons">
                    <div class="col col-12"><cf_workcube_buttons></div>
                </div>
            </div>
            <div id="designDiv" class="col col-8 text-left" style="border:solid 1px;"></div>
        </div>
    </cfoutput>
</cfform>


<script type="text/javascript">
$(document).ready(function(){
	createPage();
	$('.showCheckbox').change(function () {
		createPage();
	 });
	$('.showCheckbox').hover(
	function() {
			$(this).parent('div').parent('div').children('div[id^=screenName]').attr("class","col col-4 formbold");
			recordInfo = $(this).parent('div').parent('div').children('div[id^=screenName]').text().trim();
			$("#designDiv").find("div[class$='mainObject']").each(function( index ) {
				if($(this).text() == recordInfo)
					$(this).attr('class',$(this).attr('class')+' headbold');
			});
			}, function() {
			$(this).parent('div').parent('div').children('div[id^=screenName]').attr("class","col col-4");
			$("#designDiv").find("div[class$='mainObject headbold']").each(function( index ) {
				if($(this).text() == recordInfo)
					$(this).attr('class','col col-12 text-left mainObject');
			});
			
		}
	);
})

function createPage()
{
	$("#designDiv").html('');
	var pageDesign = $("#pageType").val();
	var controlVariable = 0; 
	rowCount = list_len(pageDesign,';');
	for(i=1;i<=rowCount;i++)
	{
		jQuery('<div/>', {
			id : 'div'+i,
			class : 'row'
		}).appendTo('#designDiv');	
		data = list_getat(pageDesign,i,';');
		for(j=1;j<=list_len(data,'-');j++)
		{
			jQuery('<div/>', {
				id : 'divRow'+i+'_'+j,
				class : 'col col-'+list_getat(data,j,'-')+' text-left',
			}).appendTo('#div'+i);
			var columnCount = $(".kolon").length;
			
			$(".kolon").each(function( index ) {
				if(!$('#show'+parseFloat(index+1)).is(':checked'))
				{
					if($(this).val() == controlVariable)
					{
						//var siraCount = $(".kolon[value='"+controlVariable+"']").length;
						/*if(siraCount > 1)
						{*/
							jQuery('<div/>', {
								id : 'divRow'+i+'_'+j+'_row',
								class : 'row'
							}).appendTo("#divRow"+i+'_'+j);
	
							jQuery('<div/>', {
								text : $("#screenName"+parseFloat(index+1)).text().trim(),
								class : 'col col-12 text-left mainObject'
							}).appendTo("#divRow"+i+'_'+j+'_row');
						/*}
						else
							$("#divRow"+i+'_'+j).text($("#divRow"+i+'_'+j).text()+$("#screenName"+parseFloat(index+1)).text().trim());*/
					}
				}
			});
			controlVariable = controlVariable + 1;
		}
	}
}

function reloadPage(element)
{
	console.log(element);
	console.log($(element).parent('div').children('input[class="realPosition"]').val());
}

</script>
