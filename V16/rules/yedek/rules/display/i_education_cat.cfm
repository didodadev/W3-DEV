

<cfinclude template="../../../V16/training/query/get_trainings.cfm">

<cfquery name="GET_TRA_CATALOG" datasource="#DSN#">
SELECT TOP 3 COUNT(TRAINING.TRAIN_ID) AS TOTAL_EDUCATION FROM TRAINING
</cfquery>



<div class="col-4 hp-right px-4">
	<div class="col-12 education">
		<div class="edu-title">
			
			<h4>Yaşam Boyu Öğrenme</h4>
			<h5>Eğitim Kataloğu</h5>
			<p>Toplam:<cfoutput query="get_tra_catalog"> #TOTAL_EDUCATION#</cfoutput> Eğitim</p>
		</div>

		
			<cfoutput query="get_trainings">	
		<div class="row edu-content">
			<h5 class="col-12"><a href="#request.self#?fuseaction=training.training_subject&train_id=#train_id#">#train_head#</a></h5>
			<p class="col-12"> <i class="wrk-keyboard-right-arrow"></i> #train_objective#</p>
			<ul class="col-12">

			<!-- VİDEO ve OKU Butonları hazır daha sonra sorulacak -->
				<cfif 1 eq 0>
				<li><a class="wrk-video-play" data-toggle="tooltip" data-placement="bottom" title="Watch" href=""></a></li>
				</cfif>
				<cfif 1 eq 0>
				<li><a class="wrk-read-book" data-toggle="tooltip" data-placement="bottom" title="Read" href=""></a></li>
				</cfif>
			</ul>
		</div>
		</cfoutput>
		<div class="col-12 cate-text">
			<a class="col-12" href="?fuseaction=training.list_training_subjects">
				Tüm Kataloğu İncelemek İçin Tıklayınız.
			</a>
		</div>
	</div>
	<div class="col-12 social-media">
		<div class="col-12 image-soc">
			<img src="../../../css/assets/template/w3-assets/images/social.jpg" class="col-12 img-fuild px-0" alt="Responsive image">
		</div>
		<div class="col-12 soc-menu">
			<ul class="row">
				<li class="col-6 s-facebook">
					<i class="wrk-facebook"></i><a class="s-facebook" href="https://www.facebook.com/Workcube.ERP" target="_blank">/WORKCUBE</a>
				</li>
				<li class="col-6 s-twitter">
					<i class="wrk-twitter"></i><a class="s-twitter" href="https://twitter.com/workcube" target="_blank">/WORKCUBE</a>
				</li>
				<li class="col-6 s-linkedin">
					<i class="wrk-linkedin"></i><a class="s-linkedin" href="https://www.linkedin.com/company/workcube-e-business-inc-" target="_blank">/WORKCUBE</a>
				</li>
				<li class="col-6 s-instagram">
					<i class="wrk-instagram"></i><a class="s-instagram" href="https://instagram.com/workcube" target="_blank">/WORKCUBE</a>
				</li>
				<li class="col-6 s-googleplus">
					<i class="wrk-google-plus"></i><a class="s-googleplus" href="https://plus.google.com/+workcube-erp" target="_blank">/WORKCUBE</a>
				</li>
				<li class="col-6 s-pinterest">
					<i class="wrk-pinterest"></i><a class="s-pinterest" href="https://www.pinterest.com/workcubeerp" target="_blank">/WORKCUBE</a>
				</li>
			</ul>
		</div>
	</div>




			
			
	
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

