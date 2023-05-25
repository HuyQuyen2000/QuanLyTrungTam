<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class registration extends Model
{
    use HasFactory;

    protected $table='registrations';
    protected $primaryKey='register_id';

    public function student(){
        return $this->belongsTo(user_account::class, 'account_id', 'account_id');
    }

    public function room(){
        return $this->belongsTo(room::class, 'room_id', 'room_id');
    }
}
