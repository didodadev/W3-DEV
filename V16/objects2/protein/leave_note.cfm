<button type="button" class="close header-color" aria-label="Close">
    <span aria-hidden="true">&times;</span>
</button>
<div class="row mb-2">
    <div class="col-md-12 pl-0">
        <svg height="50" width="50" style="float: left;">
            <image href="w3menu.png" height="50px" width="50px" />
        </svg>
        <h4 class="mt-2 header-color"> <cf_get_lang dictionary_id='46092.Leave a Note'></h4>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61766.Abone ID'></p>
        <p class="mb-0">CTLS-1290-1782-333X</p>
        <div class="span-class">
            <span class="badge badge-info mb-4 btn-color-3">LYKP</span>
            <span class="badge badge-secondary mb-4 btn-color-4">WORKDESK SILVER</span>
        </div>
    </div>
</div>   
<div class="row mb-3">
    <div class="col-md-12">                
        <div id="editor">
            <p>This is some sample content.</p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-6 col-md-6 col-lg-3">
        <label class="font-weight-bold mb-0"><cf_get_lang dictionary_id='32838.Not Bırakılan'></label>
        <p>Bahar Karden</p>
    </div>
    <div class="col-sm-6 col-md-6 col-lg-3">
        <label class="font-weight-bold mb-0"><cf_get_lang dictionary_id='30907.Not Bırakan'></label>
        <p>Bahar Karden</p>
    </div>
</div>
<button type="submit" class="btn btn-color-2"><cf_get_lang dictionary_id='61895.Meet Talep Et'></button>

<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>