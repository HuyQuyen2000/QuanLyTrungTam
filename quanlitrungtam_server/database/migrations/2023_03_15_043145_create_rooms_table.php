<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rooms', function (Blueprint $table) {
            $table->id('room_id');
            $table->string('room_name');
            $table->Integer('max_mem');
            $table->Integer('members');
            $table->string('scheduleS');
            $table->time('time_start');
            $table->time('time_end');
            $table->date('date_start');
            $table->unsignedBigInteger('account_id');
            $table->unsignedBigInteger('course_id');
            $table->unsignedBigInteger('classroom_id');
            $table->timestamps();

            $table->foreign('account_id')->references('account_id')->on('user_accounts')->onDelete('cascade');
            $table->foreign('course_id')->references('course_id')->on('courses')->onDelete('cascade');
            $table->foreign('classroom_id')->references('classroom_id')->on('class_rooms')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rooms');
    }
};
