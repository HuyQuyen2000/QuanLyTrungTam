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
        Schema::create('user_accounts', function (Blueprint $table) {
            $table->id('account_id');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('type');
            $table->string('name');
            $table->string('phone')->nullable();
            $table->timestamps();
        });

        DB::table('user_accounts')->insert(
            [
                [
                    'email' => 'admin1@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Doraemon',
                    'phone' => '012963852',
                    'type' => '1',
                ],
                [
                    'email' => 'admin2@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Nobi Nobita',
                    'phone' => '012454696',
                    'type' => '1',
                ],
                [
                    'email' => 'ngokhong@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Tôn Ngộ Không',
                    'phone' => '0939897456',
                    'type' => '2',
                ],
                [
                    'email' => 'batgioi@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Trư Bát Giới',
                    'phone' => '0922156789',
                    'type' => '2',
                ],
                [
                    'email' => 'satang@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Sa Ngộ Tịnh',
                    'phone' => '0939456852',
                    'type' => '2',
                ],
                [
                    'email' => 'binhan@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Nguyễn Bình An',
                    'phone' => '012741852',
                    'type' => '3',
                ],
                [
                    'email' => 'anbinh@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Lê An Bình',
                    'phone' => '0912546896',
                    'type' => '3',
                ],
                [
                    'email' => 'duycuong@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Trần Duy Cường',
                    'phone' => '0939879523',
                    'type' => '3',
                ],
                [
                    'email' => 'cuongduy@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Nguyễn Cường Duy',
                    'phone' => '0939222456',
                    'type' => '3',
                ],
                [
                    'email' => 'kimgia@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Lê Kim Gia',
                    'phone' => '0956852693',
                    'type' => '3',
                ],
                [
                    'email' => 'anhhong@gmail.com',
                    'password' => Hash::make('123456'),
                    'name' => 'Nguyễn Ánh Hồng',
                    'phone' => '0912456123',
                    'type' => '3',
                ],
                // [
                //     'email' => 'nhatkhang@gmail.com',
                //     'password' => Hash::make('123456'),
                //     'name' => 'Trần Nhật Khang',
                //     'phone' => '0939879455',
                //     'type' => '3',
                // ]

            ]
            
            );
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_accounts');
    }
};
