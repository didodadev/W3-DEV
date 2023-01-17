<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<div class="childsorterElementTitle">
    <span><cf_get_lang dictionary_id="55162.Pozisyonlar"></span>
    <!--- <div class="col col-1"><cfif  isdefined ("attributes.visb") ><i class="fa fa-eye-slash"></i></cfif></div>
    <div class="col col-1"><cfif isdefined ("attributes.req") ><i class="fa fa-asterisk"></i></cfif></div>
    <div class="col col-1"><i class="fa fa-lock"></i></div> --->
</div>
<cfoutput query="GET_POSITION_CATS">
    <div class="childsorterElement row" id="#attributes.divId#-#position_cat_id#">
        <div class="childsorterElementName">
        	<a href="javascript://" onClick="openEmployee('#position_cat_id#');return false">
				<!--- <i class="icon-add" style="font-style:normal"></i> --->
                #position_cat#
            </a>
            <input type="hidden" id="posCatId" name="posCatId" value="#position_cat_id#">
		</div>
		<div class="childsorterElementPermission">
			<cfif  isdefined ("attributes.visb") >
                <input type="checkbox" id="visible" name="visible" <cfif attributes.visb > checked </cfif>  value="#position_cat_id#" onClick="updateObject(this,#position_cat_id#)" title="#getLang('','Aktif/Pasif',58515)#">
			 </cfif>
			 <cfif isdefined ("attributes.req") >
                <input type="checkbox" id="require" name="require"  <cfif attributes.req > checked </cfif> value="#position_cat_id#" onClick="updateObject(this,#position_cat_id#)" title="#getLang('','Zorunludur',45058)#">
			</cfif>
			<input type="checkbox" id="readonly" name="readonly" <cfif attributes.read > checked </cfif> value="#position_cat_id#" onClick="updateObject(this,#position_cat_id#)" title="#getLang('','Sadece Okunur',43733)#">
		</div>
    </div>         
      	
</cfoutput>
<script type="text/javascript">
	$(function(){
		
			var object 		= formObjects.positions;
			var formItem	= '<cfoutput>#attributes.divId#</cfoutput>';
			var visbId 		= 'visible';
			var reqId  		= 'require';
			var readId 		= 'readonly';

			$.each(object, function (k,v){
					//console.log(k,v)

						$.each(v, function(ke,va){
							//console.log (ke,va)		
						
								var control = $.grep(va, function (v,k){ if  (v.item){ return v.item.data == formItem }else { return } });

								if (control.length > 0) {
									
										var positionRow = $('#' + formItem + '-' + ke );
								
										var	visb	= control[0].item.visb; 
										var req		= control[0].item.req;
										var read	= control[0].item.read;
										
										var chckVisb	= positionRow.find('input#' + visbId )
										var chckReq		= positionRow.find('input#' + reqId )
										var chckRead	= positionRow.find('input#' + readId )
	
											chckVisb.prop('checked', visb);
											chckReq.prop('checked', req);
											chckRead.prop('checked', read);
									
									}	// control.length;								
							
							}); //each v
			
				}); // each object
	
		}); //ready



</script>
