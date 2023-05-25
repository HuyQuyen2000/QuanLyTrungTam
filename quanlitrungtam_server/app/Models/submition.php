<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class submition extends Model
{
    use HasFactory;

    protected $table='submitions';
    protected $primaryKey='submit_id';

    public function task(){
        return $this->belongsTo(task::class, 'task_id', 'task_id');
    }

    public function user_account(){
        return $this->belongsTo(user_account::class, 'account_id', 'account_id');
    }
}
