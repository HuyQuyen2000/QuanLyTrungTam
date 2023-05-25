<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class schedule extends Model
{
    use HasFactory;

    protected $table='schedules';
    protected $primaryKey='schedule_id';

    public function room(){
        return $this->belongsTo(room::class, 'room_id', 'room_id');
    }

}