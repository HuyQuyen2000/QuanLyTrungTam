<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class schedule_temp extends Model
{
    use HasFactory;

    protected $table='schedule_temps';
    protected $primaryKey='scheduleTemp_id';

    // public function room(){
    //     return $this->belongsTo(room::class, 'room_id', 'room_id');
    // }

}