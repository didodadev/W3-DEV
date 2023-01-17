<cfif (not isdefined('cookie.is_message') or not len(cookie.is_message)) and attributes.fuseaction contains 'welcome' and (not isdefined('session.pp.userid') or not isdefined('session.ww.userid')) and (session_base.language is 'tr')>
	<cfset getContentHomePage = createObject("component","worknet.objects.worknet_objects").getContents(content_cat_id:attributes.homePageContentCatId,isHomePage:1) />
	<cfif getContentHomePage.recordcount>
		<style type="text/css">
		#popupcontainer {
			position:absolute;
			z-index: 9999;
			left: 50%;
			top: 50%;
			margin-top: -250px;
			margin-left: -375px;
			width: 750px;
			max-height: 500px;
			display:none;
		}
		
		#FLVPlayer {
		   display:none;
		}
		
		.flashcontent {
			display: none;
			overflow:auto;
		}
		</style>
			
		<script type="text/javascript">
			$(document).ready(function()
			{
				   $.popup({
					content: $(".popupcontainer"),
					close: $("#popupCloseButton"),
					width: 600,
					height: 500,
					dispose: $(".popupcontainer")
				}, function () {
	
					  $(".flashcontent").css("display", "block");
					  $("#FLVPlayer").css("display", "block");
				});
				$(".popupcontainer").css('display', 'none');
				$(".popupcontainer").first().css('display', 'block');
				$(".popupcontainer").first().removeClass('pasif').addClass('aktif');

			});
			
			function kapat()
			{
				AjaxPageLoad('index.cfm?fuseaction=worknet.emptypopup_message_cookie');
			}
		</script>
		<cfoutput query="getContentHomePage">
			<div class="popupcontainer pasif">
				<div class="flashcontent" style="width:712px; height: auto; margin: 36px auto;" align="center">
				 <div class="childrenFlashContent"style="float:left;width:100%;height:auto;overflow:hidden;">
					#cont_body#
				 </div>
				</div>
			</div>
		</cfoutput>
	</cfif>
</cfif>
