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
        Schema::create('courses', function (Blueprint $table) {
            $table->id('course_id');
            $table->string('name');
            // $table->Integer('max_mem');
            $table->Integer('lessons');
            $table->BigInteger('cost');
            $table->unsignedBigInteger('language_id');
            $table->timestamps();

            $table->foreign('language_id')->references('language_id')->on('languages')->onDelete('cascade');

        });

        DB::table('courses')->insert(
            [
                [
                    'name' => 'VSTEP A2',
                    // 'max_mem' => 30,
                    'lessons' => 24,
                    'cost' => 1500000,
                    'language_id' => 1,
                ],
                [
                    'name' => 'VSTEP B1',
                    // 'max_mem' => 30,
                    'lessons' => 24,
                    'cost' => 2000000,
                    'language_id' => 1,
                ],
                [
                    'name' => 'VSTEP B2',
                    // 'max_mem' => 30,
                    'lessons' => 24,
                    'cost' => 3500000,
                    'language_id' => 1,
                ],
                [
                    'name' => 'VSTEP C1',
                    // 'max_mem' => 30,
                    'lessons' => 30,
                    'cost' => 4500000,
                    'language_id' => 1,
                ],
                [
                    'name' => 'N5',
                    // 'max_mem' => 20,
                    'lessons' => 24,
                    'cost' => 1000000,
                    'language_id' => 2,
                ],
                [
                    'name' => 'N4',
                    // 'max_mem' => 20,
                    'lessons' => 24,
                    'cost' => 1500000,
                    'language_id' => 2,
                ]

            ]
            
            );

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('courses');
    }
};