<?php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Capsule\Manager as Capsule;

class ArqbackupInit extends Migration
{
    public function up()
    {
        $capsule = new Capsule();
        $capsule::schema()->create('arqbackup', function (Blueprint $table) {
            $table->increments('id');
            $table->string('serial_number');
            $table->string('version')->nullable();
            $table->text('source')->nullable();
            $table->text('destination')->nullable();
            $table->integer('completed')->nullable();
            $table->text('amount')->nullable();
            $table->text('error')->nullable();
            $table->text('status')->nullable();

            $table->unique('serial_number');
            $table->index('version');
            $table->index('source');
            $table->index('destination');
            $table->index('completed');
            $table->index('amount');
            $table->index('error');
            $table->index('status');

        });
    }
    
    public function down()
    {
        $capsule = new Capsule();
        $capsule::schema()->dropIfExists('arqbackup');
    }
}
