<?php

use munkireport\models\MRModel as Eloquent;

class Arqbackup_model extends Eloquent
{
    protected $table = 'arqbackup';

    protected $hidden = ['id', 'serial_number'];

    protected $fillable = [
      'serial_number', //$this->rt['serial_number'] = 'VARCHAR(255) UNIQUE';
      'version',  // Version number of ARQbackup software
      'source',  // Name of backup source material
      'destination',  // Name of backup destintation
      'completed',  // Timestamp of last successful backup
      'amount',  // Amount backed up in GB
      'error',   // Error description (if listed)    
      'status',   // Error condition (lists "Error" if there is an error message)

    ];
    
    /**
     * Get statistics
     *
     * @return void
     * @author
     **/
    public function get_stats($hours)
    {
        $now = time();
        $today = $now - 3600 * 24;
        $week_ago = $now - 3600 * 24 * 7;
        $month_ago = $now - 3600 * 24 * 30;
        $sql = "SELECT COUNT(1) as total, 
			COUNT(CASE WHEN completed > '$today' THEN 1 END) AS today, 
			COUNT(CASE WHEN completed < '$today' THEN 1 END) AS tardy,
			COUNT(CASE WHEN error = 1 THEN 1 END) AS error
			FROM arqbackup
			LEFT JOIN reportdata USING (serial_number)
			".get_machine_group_filter();
        return current($this->query($sql));
    }

}

