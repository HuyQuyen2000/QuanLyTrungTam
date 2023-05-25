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
        Schema::create('languages', function (Blueprint $table) {
            $table->id('language_id');
            $table->string('name');
            $table->timestamps();
        });

        DB::table('languages')->insert(
            [
                [
                    'name' => 'Tiếng Anh'
                ],
                [
                    'name' => 'Tiếng Nhật'
                ]

            ]
            
            );

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('languages');
    }
};