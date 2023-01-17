<button type="button" class="close header-color" aria-label="Close">
    <span aria-hidden="true">&times;</span>
</button>
<div class="row mb-2">
    <div class="col-md-12 pl-0">
        <h4 class="mt-2 header-color"><i class="far fa-handshake"></i> <cf_get_lang dictionary_id='61629.Anlaşma Talebi'></h4>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <p class="mb-0"><cf_get_lang dictionary_id='56406.İşveren'> : Marcus Antonius / Roma İmparatorluğu </p>
        <p><cf_get_lang dictionary_id='61812.Yüklenici'> : Boti Can / Botinn </p>
    </div>
</div>

<div class="table-responsive-sm">
    <table class="table table-borderless">
        <thead class="text-center">
            <tr>
                <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                <th><cf_get_lang dictionary_id='38215.Öngörülen Süre'></th>
                <th><cf_get_lang dictionary_id='61800.Anlaşma Tutarı'></th>
            </tr>
        </thead>
        <tbody class="border-top text-center">
            <tr>
                <td>05.02.2020</td>
                <td>32 saat</td>
                <td>1.200 USD</td>
            </tr>
        </tbody>
    </table>
</div>
<div class="row mb-3">
    <div class="col-md-12">
        <label><cf_get_lang dictionary_id='61801.Not ekleyebilirsiniz'>.</label>
        <div id="editor">
            <p>This is some sample content.</p>
        </div>
    </div>
</div>
<div class="row mb-3">
    <div class="col-md-12">
        <label class="checkbox-container font-weight-bold"><cf_get_lang dictionary_id='61854.?'><cf_get_lang dictionary_id='61804.Sözleşme niteliği taşır.'>
            <input type="checkbox">
            <span class="checkmark"></span>
        </label>    
        <a href="#" class="none-decoration ml-4 pl-1">
            ><cf_get_lang dictionary_id='61802.Sözleşme detaylarını okuyunuz.'>
        </a>                                                                
    </div>
</div> 
<button type="submit" class="btn btn-color-2 float-right"><i class="fa fa-check"></i> <cf_get_lang dictionary_id='59031.Kaydet'></button>                

<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>