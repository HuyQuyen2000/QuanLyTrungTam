<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class class_room extends Model
{
    use HasFactory;

    protected $table='class_rooms';
    protected $primaryKey='classroom_id';



    public function room(){
        return $this->hasMany(room::class, 'classroom_id', 'classroom_id');
    }



}