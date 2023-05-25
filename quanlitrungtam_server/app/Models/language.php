<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class language extends Model
{
    use HasFactory;

    protected $table='languages';
    protected $primaryKey='language_id';

    public function course(){
        return $this->hasMany(course::class, 'language_id', 'language_id');
    }


}