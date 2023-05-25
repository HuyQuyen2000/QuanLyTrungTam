<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class room extends Model
{
    use HasFactory;

    protected $table='rooms';
    protected $primaryKey='room_id';

    // protected $casts=[
    //     'date_start' => 'datetime:D Y-m-d',
    // ];
    // protected $fillable = ['classroom_id'];

    public function teacher(){
        return $this->belongsTo(user_account::class, 'account_id', 'account_id');
    }

    public function course(){
        return $this->belongsTo(course::class, 'course_id', 'course_id');
    }

    public function class_room(){
        return $this->belongsTo(class_room::class, 'classroom_id', 'classroom_id');
    }

    public function registration(){
        return $this->hasMany(registration::class, 'room_id', 'room_id');
    }

    public function post(){
        return $this->hasMany(post::class, 'room_id', 'room_id');
    }

    public function schedule(){
        return $this->hasMany(schedule::class, 'room_id', 'room_id');
    }

}
