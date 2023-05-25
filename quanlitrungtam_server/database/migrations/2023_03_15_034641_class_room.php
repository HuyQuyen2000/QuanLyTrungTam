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
        Schema::create('class_rooms', function (Blueprint $table) {
            $table->id('classroom_id');
            $table->string('name');
            $table->Integer('capacity');
            $table->string('note')->nullable();
            $table->timestamps();

        });

        DB::table('class_rooms')->insert(
            [
                [
                    'name' => '101',
                    'capacity' => 30,
                    'note' => '',
                ],
                [
                    'name' => '102',
                    'capacity' => 30,
                    'note' => 'Bị hư máy chiếu',
                ],
                [
                    'name' => '201',
                    'capacity' => 40,
                    'note' => '',
                ],
                [
                    'name' => '202',
                    'capacity' => 40,
                    'note' => 'Thiếu ghế ngồi cho học viên',
                ]

            ]
            
            );


    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('class_rooms');
    }
};