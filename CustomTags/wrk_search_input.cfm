<cfparam name="attributes.name" default="">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.checkbox" default="">
<cfparam name="attributes.columnlist" default="">
<cfparam name="attributes.check_column" default="">

	<cfoutput>
    	<cfif isdefined("caller.#attributes.name#") > 
        	<cfset value = evaluate('caller.#attributes.name#') >	
    <cfelse>
        	<cfset value = "" >	
        </cfif> 
		<ul style="padding:0;margin:0;list-style-type:none">
			<li>
				<input placeholder="<cf_get_lang dictionary_id="57701.Filtre Ediniz">" type="text" name="#attributes.name#" id="#attributes.id#" title="#attributes.title#"  value="#value#" style="#attributes.style#" autocomplete="off"/>
					<ul class="ui-dropdown-menu ui-dropdown-menu_type2">
						<cfloop from="1" to="#listlen(attributes.checkbox)#" index="ccc">
							<cfoutput>
								<li>
									<div class="form-group">
										<label>
											#ListgetAt(attributes.checkbox,ccc)#
											<input type="checkbox" id="#ListgetAt(attributes.columnlist,ccc)#" 
											<cfloop from="1" to="#listlen(attributes.check_column)#" index="aaa">
												<cfif ListgetAt(attributes.columnlist,ccc) is ListgetAt(attributes.check_column,aaa)>
													checked="checked"	
												</cfif>
											</cfloop>
											name="#ListgetAt(attributes.columnlist,ccc)#" value="1"/>
										</label>
									 </div>	
								</li>
							 </cfoutput>
						</cfloop> 
					</ul>  
			</li>
		</ul>
    </cfoutput>
  
    
		
   

<script type="text/javascript">

	$(function(){
		$("<cfoutput>###attributes.id#</cfoutput>").parent().hover(function(){
			var offsetY = $(this).outerHeight();
			var offsetX = "0";
			 $(".ui-dropdown-menu").
			 css({
				 "left":offsetX,
				 "top":offsetY,
			 }).
			 show();
			 $(this).parent().css("position","relative");
		}, function(){
			 $(".ui-dropdown-menu").hide();
			 $(this).parent().css("position","initial");
		});
	})

</script>


