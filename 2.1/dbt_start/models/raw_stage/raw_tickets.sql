SELECT t.ticket_no
     , tf.flight_id
     , t.passenger_id
     , t.passenger_name
     , t.contact_data
     , bp.boarding_no
     , bp.seat_no
     , tf.fare_conditions
     , tf.amount
     , b.book_ref
     , b.book_date
     , b.total_amount
  FROM {{ source('raw', 'tickets')}}                AS t
  LEFT JOIN {{ source('raw', 'bookings') }}         AS b
    ON b.book_ref = t.book_ref
  LEFT JOIN {{ source('raw', 'ticket_flights') }}   AS tf
    ON t.ticket_no = tf.ticket_no
  LEFT JOIN {{ source('raw', 'boarding_passes') }}  AS bp
    ON bp.flight_id = tf.flight_id
   AND bp.ticket_no = tf.ticket_no
 WHERE b.book_date BETWEEN TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY')
                         - INTERVAL '1 month 1 day'
                       AND TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY')
                         + INTERVAL '1 day'
    OR {{ var('full_load') }}
