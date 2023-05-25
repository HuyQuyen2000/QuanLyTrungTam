<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class post extends Model
{
    use HasFactory;

    protected $table='posts';
    protected $primaryKey='post_id';

    public function teacher(){
        return $this->belongsTo(user_account::class, 'account_id', 'account_id');
    }

    public function room(){
        return $this->belongsTo(room::class, 'room_id', 'room_id');
    }

    public function task(){
        return $this->hasMany(task::class, 'post_id', 'post_id');
    }

    public function document(){
        return $this->hasMany(document::class, 'post_id', 'post_id');
    }

    public function comment(){
        return $this->hasMany(comment::class, 'post_id', 'post_id');
    }
}
