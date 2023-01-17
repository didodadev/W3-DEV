<cfsetting showdebugoutput="no">
<cfparam name="URL.folder" default="Gelen Kutusu">
<cfset URL.folder = URLDecode(URL.folder,"utf-8")>

<cfparam name="URL.type" default="">
<cfparam name="URL.ara" default="">

<!--- ARAMA İÇİN --->

<cfset sorgu="">
<cfset str="">
<cfswitch expression="#Trim(URL.type)#"> 
    <cfcase value="0"> 
        <cfset sorgu="WHERE FROMID='"&Trim(URL.ara)&"'">
    </cfcase> 
    <cfcase value="1"> 
        <cfset sorgu="WHERE SUBJECT='"&Trim(URL.ara)&"'">
    </cfcase>
</cfswitch> 


<!--- SIRALAMA İÇİN --->
<cfparam name="URL.order" default=4>
<cfparam name="URL.direction" default="desc">

<cfset order="">
<cfset direction=URL.direction>
<cfset str="">
<cfswitch expression="#Trim(URL.order)#"> 
    <cfcase value="0"> 
        <cfset order="IMPORTANCE "&direction>
		<cfset str="Önem Sırasına Göre">
    </cfcase> 
    <cfcase value="1"> 
        <cfset order="ISREAD "&direction>
		<cfset str="Okunma Durumuna Göre">
    </cfcase> 
	<cfcase value="2"> 
        <cfset order="FROMID "&direction>
		<cfset str="Gönderene Göre">
    </cfcase>
	<cfcase value="3"> 
         <cfset order="SUBJECT "&direction>
		 <cfset str="Konua Göre">
    </cfcase> 
	<cfcase value="4"> 
        <cfset order="TIMERECEIVED "&direction>
		<cfset str="Alınma Tarihine Göre">
    </cfcase> 		 
    <cfdefaultcase> 
		<cfset order="TIMERECEIVED "&direction>
		<cfset str="Alınma Tarihine Göre">
    </cfdefaultcase> 
</cfswitch>

<!--- Sayfalama İçin --->
<cfparam name="attributes.startrow" default="0">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=15>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfinclude template="exchange_conn.cfm">

<cfexchangemail action="get" connection="wrk_exchange_connection" name="mails">
  <cfexchangefilter name="folder" value="#URL.folder#">
	<cfswitch expression="#Trim(URL.type)#"> 
    <cfcase value="0"> 
        <cfexchangefilter name="FROMID" value="#Trim(URL.ara)#">
    </cfcase> 
    <cfcase value="1"> 
        <cfexchangefilter name="SUBJECT" value="#Trim(URL.ara)#">
    </cfcase>
</cfswitch> 
</cfexchangemail>

<cfset meetingData=evaluate("mails")>

<cfquery dbtype="query" name="theResponses">
	SELECT * FROM meetingData order by #order#
</cfquery>

<cfparam name="attributes.totalrecords" default="#theResponses.recordcount#">
 <div style="width:100%; height:417px;overflow:auto;">
 <form method="post" id="mails_form" name="mails_form" >	
 	<input type="text" id="islem" name="islem" value="delete" style="display:none"/>
	<input type="text" id="folder" name="folder" value="<cfoutput>#URL.folder#</cfoutput>" style="display:none"/>
	<input type="text" id="pvalue" name="pvalue" value="1" style="display:none"/>  
   <table cellspacing="1" id="table_list" OnSelectStart="return false" width="100%">       
	  <cfset i=0>
      <cfoutput query="theResponses" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif not uid is "">
			<cfset start = Find("<",uid) + 1>
			<cfset count = Find(">",uid) - start>
			<cfset uid2 = Mid(uid,start,count)>	
		<cfelse>
			<cfset uid2 = uid>	
		</cfif>	
        <tr id="tr_#i#" oncontextmenu="showmenuie5(event)" onmouseover="mouseover(this)" onmouseup="mouseclick(this,'#URLEncodedFormat(uid2)#',#i#,event)" onmouseout="mouseout(this)" height="35">
          <td id="tr_#uid2#">
		  	<table id="table_#i#" style="border:solid 1px silver" width="100%" <cfif NOT ISREAD IS "YES">style="font-weight:bold"</cfif>>
              <tr>
                <td width="15" id="tr_#uid2#_img_isread">
					<cfif ISREAD IS "YES">
                    <img src="/images/exchange/read.gif">
                    <cfelse>
                    <img src="/images/exchange/unread.gif">
                  </cfif></td>
                <td id="tr_#uid2#_mail_id"><input id="chk_#i#" type="checkbox" name="mail_id" value="#uid2#" style="display:none"/>
                  <b>#FROMID#</b></td>
                <td width="80"  style="text-align:right;">#DateFormat(TIMERECEIVED,"dd mmm")# #TimeFormat(TIMERECEIVED,timeformat_style)#</td>
              </tr>
              <tr>
                <td align="center" id="tr_#uid2#_img_importance"><cfif IMPORTANCE IS "High">
                    <img src="/images/exchange/exclamation.gif" width="14"/>
                  </cfif>
				  <cfif IMPORTANCE IS "Low">
                    <img src="/images/exchange/down.gif"  width="14"/>
                  </cfif>
				  </td>
                <td><cfif SUBJECT IS "">
                    .:Konu Yok:.
                    <cfelse>
                    #SUBJECT#
                  </cfif></td>
                <td  style="text-align:right;"><cfif HASATTACHMENT>
                    <img src="/images/exchange/paperclip.gif" />
                  </cfif></td>
              </tr>
            </table>
			</td>
        </tr>
		<cfset i++>
      </cfoutput>  
   </table>
   </form>
   </div>


   <div style="width:100%; height:25px; border:solid 1px #a7caed; background-color:#dce9f5" >   
   <table width="100%">
   <tr>
   	<td align="left"><cfoutput> #attributes.startrow# - #attributes.startrow + attributes.maxrows-1# \ Toplam Kayıt : #attributes.totalrecords# </cfoutput></td>
	<cfset adres = "folder="&URL.folder&"&order="&URL.order&"&direction="&URL.direction>
	<cfif (not URL.ara is "") and (not URL.type is "")>
		<cfset adres = "folder="&URL.folder&"&order="&URL.order&"&direction="&URL.direction&"&ara="&URL.ara&"&type="&URL.type>
	</cfif>
	<td style="text-align:right;">
	<cfif i gt 0>
	<cfoutput><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" adres="test.emptypopup_mails_list&#adres#" isAjax="true" target="mails_list"></cfoutput>
	</cfif>
</td>
   </tr>
   </table>		
  </div>

