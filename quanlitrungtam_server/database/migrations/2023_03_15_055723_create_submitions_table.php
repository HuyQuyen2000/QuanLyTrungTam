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
        Schema::create('submitions', function (Blueprint $table) {
            $table->id('submit_id');
            $table->unsignedBigInteger('task_id');
            $table->unsignedBigInteger('account_id');
            $table->string('document_name')->nullable();
            $table->string('status');
            $table->datetime('submit_time')->nullable();
            $table->timestamps();

            $table->foreign('task_id')->references('task_id')->on('tasks')->onDelete('cascade');
            $table->foreign('account_id')->references('account_id')->on('user_accounts')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('submitions');
    }
};
