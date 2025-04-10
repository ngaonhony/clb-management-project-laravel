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
    Schema::create('users', function (Blueprint $table) {
        $table->id();
        $table->string('username');
        $table->string('password');
        $table->string('email')->unique();
        $table->string('phone')->unique();
        $table->string('gender')->nullable();
        $table->text('description')->nullable();
        $table->string('role')->default('User')->nullable();
        $table->string('resetPasswordToken')->nullable();
        $table->timestamp('resetPasswordExpires')->nullable();
        $table->boolean('email_verified')->default(false);
        $table->string('verification_token')->nullable();
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
};
