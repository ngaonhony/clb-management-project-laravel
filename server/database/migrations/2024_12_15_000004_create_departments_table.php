<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
{
    Schema::create('departments', function (Blueprint $table) {
        $table->id();
        $table->foreignId('club_id')->constrained('clubs');
        $table->string('name');
        $table->boolean('manage_events')->default(false);
        $table->boolean('create_events')->default(false);
        $table->boolean('manage_members')->default(false);
        $table->boolean('view_notifications')->default(false);
    });
}

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('departments');
    }
};
