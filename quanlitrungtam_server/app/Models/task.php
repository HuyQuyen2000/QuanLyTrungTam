<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class task extends Model
{
    use HasFactory;

    protected $table='tasks';
    protected $primaryKey='task_id';

    public function post(){
        return $this->belongsTo(post::class, 'post_id', 'post_id');
    }

    public function submition(){
        return $this->hasMany(submition::class, 'task_id', 'task_id');
    }
}
