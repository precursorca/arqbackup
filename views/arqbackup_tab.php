<div id="arqbackup-tab"></div>
<h2 data-i18n="arqbackup.title"></h2>

<table id="arqbackup-tab-table"
       class="table table-responsive table-striped table-condensed"
       style="max-width: 600px;">
    <tbody></tbody>
</table>

<script>
$(document).on('appReady', function(){
    $.getJSON(appUrl + '/module/arqbackup/get_data/' + serialNumber, function(data){
        var table = $('#arqbackup-tab-table');
        $.each(data, function(key,val){
            var th = $('<th>').text(i18n.t('arqbackup.column.' + key));
            var td = $('<td>').text(val);
            table.append($('<tr>').append(th, td));
        });
    });
});
</script>
