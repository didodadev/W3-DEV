<cfparam name="attributes.keyword" default="">
<form class="card card-sm border-0 search-form" method="GET" action="<cfoutput>#site_language_path#</cfoutput>/category_detail">
	<div class="row justify-content-center mt-5">
		<div class="col col-12 col-sm-10 col-md-9 col-lg-8 text-center text-success">
			<h4><cf_get_lang dictionary_id='64256.Wikiye Hoşgeldiniz'>!</h4>
		</div>
	</div>
	<div class="row justify-content-center mb-0 ">
		<div class="col-12 col-md-10 col-lg-8">
            <div class="card-body row no-gutters align-items-center searchArea px-0 px-sm-0 px-md-3 px-lg-4">	
                <div class="col">
                    <i class="fas fa-search h4 text-body"></i>
                    <input class="form-control form-control-lg form-control-borderless searchInput" v-model="keyword" type="search" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='64255.İhtiyaç duyduğunuz bilgiyi arayın'>">
                </div>
                <div class="col-auto">
                    <button class="btn btn-lg btn-success searchButton" type="submit" style="border-bottom-left-radius: 0;border-top-left-radius: 0;"><cf_get_lang dictionary_id='57565.Ara'></button>
                </div>
            </div>
		</div>
	</div>			
</form>