-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Getting the description of the crime scene reports

SELECT description
FROM crime_scene_reports
WHERE street LIKE "%Chamberlin Street%" AND year = 2020 AND month = 7 AND day = 28;
-- Getting the transcript of the interviews with witnesses
SELECT transcript
FROM interviews
WHERE transcript LIKE "%courthouse%" AND year = 2020 AND month = 7 AND day = 28;

--Getting the suspected thief data from ATM transaction
WITH suspected_atm AS (
      SELECT p.name AS name, p.phone_number AS phone_number, p.passport_number, p.license_plate
      FROM atm_transactions ats
      JOIN bank_accounts ba
      ON ats.account_number = ba.account_number
      JOIN people p
      ON ba.person_id = p.id
      WHERE ats.atm_location LIKE 'Fifer Street' AND ats.transaction_type = 'withdraw' AND year = 2020 AND month = 7 AND day = 28),
-- Getting the data from calls
suspected_phone_numbers AS (
     SELECT phc.caller AS caller, phc.receiver AS receiver
     FROM phone_calls phc
     JOIN suspected_atm
     ON phc.caller = suspected_atm.phone_number
     WHERE year = 2020 AND month = 7 AND day = 28 AND phc.duration < 60),

-- GETTING the suspected theif and passport and phone number of his accomplice
caller_passport_receiver AS (SELECT p.name AS caller_name, p.passport_number AS passport_number, spn.receiver AS receiver
FROM people p
JOIN suspected_phone_numbers spn
ON p.phone_number = spn.caller)

-- Getting Thief name, passport_number, destination city, and the accomplice phone_number
SELECT caller_name AS thief, receiver AS accomplice_phone_number, ap.city AS destination_city
FROM flights f
JOIN passengers psg
ON f.id = psg.flight_id
JOIN caller_passport_receiver cpr
ON cpr.passport_number = psg.passport_number
JOIN airports ap
ON f.destination_airport_id = ap.id
WHERE year = 2020 AND month = 7 AND day = 29
ORDER BY f.hour, f.minute
LIMIT 1;


-- Getting the name of the accomplice
SELECT name AS Accomplice
FROM people
WHERE phone_number = "(375) 555-8161";
