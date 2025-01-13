<?php

// Database seeder
// Please visit https://github.com/fzaninotto/Faker for more options

/** @var \Illuminate\Database\Eloquent\Factory $factory */
$factory->define(Arqbackup_model::class, function (Faker\Generator $faker) {

    return [
        'version' => $faker->word(),
        'source' => $faker->word(),
        'destination' => $faker->word(),
        'completed' => $faker->dateTimeBetween('-4 months', 'now'),
        'amount' => $faker->word(),
        'stored' => $faker->word(),
        'error' => $faker->word(),
        'status' => 'Error',
    ];
});
