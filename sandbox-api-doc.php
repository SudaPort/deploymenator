<?php

 
End Point -  api.sandbox.gurosh.com/
    Main Function ->  index
    Action     -> index


//nonce
End Point -  api.sandbox.gurosh.com/nonce
    Main Function -> nonce
    Action     -> index
--------------------

//enrollments
End Point - Get  - api.sandbox.gurosh.com/enrollments
    Main Function -> enrollments
    Action     -> list
    $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/enrollments',
            [
                'query' => ['type' => 'agent'],
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


//get agent enrollment data  with agent data) by enrollment token and company_code  send as post parameter)
End Point - Get  - api.sandbox.gurosh.com/enrollment/agent/get/{id}
    Main Function -> enrollments
    Action     -> getAgentEnrollment


//get user enrollment data  with user data) by enrollment token
End Point - Get  - api.sandbox.gurosh.com/enrollment/user/get/{id}
    Main Function -> enrollments
    Action     -> getUserEnrollment


//can call anyone with token nonce not need account type dont checked
End Point - Post /enrollments/decline/{id}
    Main Function -> enrollments
    Action     -> decline


//can call anyone with token nonce not need account type dont checked
End Point - Post  - api.sandbox.gurosh.com/enrollments/accept/{id}
    Main Function -> enrollments
    Action     -> accept
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/enrollments/accept/' . $last_enrollment->id,
            [
                'http_errors' => false,
                'form_params' => [
                    "token" => $last_enrollment->otp,
                    "account_id" => 'GDMAIWXEOBXARXUMBMNW3WTENXZR5TWMJIZHIWQEO22CZVCOS5SHPI6X',
                    "tx_trust" => 'test',
                    "login" => 'test'
                ]
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/enrollments/approve/{id}
    Main Function -> enrollments
    Action     -> approve
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/enrollments/approve/' . $enrollment_after->id,
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
            ]
        );
--------------------

//admins
End Point - Get  - api.sandbox.gurosh.com/admins
    Main Function -> admins
    Action     -> list


End Point - Post  - api.sandbox.gurosh.com/admins
    Main Function -> admins
    Action     -> create


End Point - Get  - api.sandbox.gurosh.com/admins/{account_id}
    Main Function -> admins
    Action     -> get


End Point - Post  - api.sandbox.gurosh.com/admins/delete
    Main Function -> admins
    Action     -> delete
--------------------

//agents
End Point - Get  - api.sandbox.gurosh.com/agents
    Main Function -> agents
    Action     -> list
    $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/agents',
            [
                'query' => ['company_code' => $cmp_code],
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/agents
    Main Function -> agents
    Action     -> create
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/agents',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "type" => Agents::TYPE_MERCHANT,
                    "asset" => 'EUAH',
                    "company_code" => $cmp_code
                ]
            ]
        );
--------------------

//bans
End Point - Get  - api.sandbox.gurosh.com/bans
    Main Function -> bans
    Action     -> list
     $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/invoices/bans',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/bans
    Main Function -> bans
    Action     -> create
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/invoices/bans',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "account_id" => $account_id,
                    "seconds"    => $seconds
                ]
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/bans/delete
    Main Function -> bans
    Action     -> delete
--------------------

//cards
End Point - Get  - api.sandbox.gurosh.com/cards/{id}
    Main Function -> 
    Action     -> get
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/cards/' . $account_id,
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Get  - api.sandbox.gurosh.com/cards
    Main Function -> cards
    Action     -> list
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/cards',
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Post  - api.sandbox.gurosh.com/cards
    Main Function -> cards
    Action     -> createCards
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/cards',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "account_id" => $account_id,
                    "seed"       => $seed,
                    "amount"     => $amount,
                    "asset"      => $asset,
                    "type"       => $type
                ]
            ]
        );
--------------------

//companie
End Point - Get  - api.sandbox.gurosh.com/companies/{id}
    Main Function -> companies
    Action     -> get
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/companies/' . $code,
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Get  - api.sandbox.gurosh.com/companies
    Main Function -> companies
    Action     -> list
    $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/companies',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/companies
    Main Function -> companies
    Action     -> create
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/companies',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "code"      => $cmp_code,
                    "title"     => 'test_data',
                    "address"   => 'test_data',
                    "email"     => 'for0work0@gmail.com',
                    "phone"     => '123123123'
                ]
            ]
        );
--------------------

//invoices
End Point - Get  - api.sandbox.gurosh.com/invoices
    Main Function -> invoices
    Action     -> list
    $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/invoices',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


End Point - Get  - api.sandbox.gurosh.com/invoices/{id}
    Main Function -> invoices
    Action     -> get
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/invoices/' . $id,
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Post  - api.sandbox.gurosh.com/invoices
    Main Function -> invoices
    Action     -> create
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/invoices',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "asset"  => $asset,
                    "amount" => $amount,
                    "memo"   => $memo
                ]
            ]
        );


End Point - Get  - api.sandbox.gurosh.com/invoices/statistics
    Main Function -> invoices
    Action     -> statistics
--------------------

//merchant
End Point - Get  - api.sandbox.gurosh.com/merchant/stores
    Main Function -> merchant
    Action     -> storesList
    $response = $client->request(
            'GET',
            'http://api.sandbox.gurosh.com/merchant/stores',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false
            ]
        );


End Point - Post  - api.sandbox.gurosh.com/merchant/stores
    Main Function -> merchant
    Action     -> storesCreate
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/merchant/stores',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "url"  => $url,
                    "name" => $name
                ]
            ]
        );


End Point - Get  - api.sandbox.gurosh.com/merchant/orders
    Main Function -> merchant
    Action     -> ordersList
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/merchant/stores/' . $cur_store->store_id . '/orders',
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Get  - api.sandbox.gurosh.com/merchant/orders/{id}
    Main Function -> merchant
    Action     -> ordersGet
     $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/merchant/orders/' . $cur_order->id,
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Post  - api.sandbox.gurosh.com/merchant/orders
    Main Function -> merchant
    Action     -> ordersCreate
    $response = $client->request(
                'POST',
                'http://api.sandbox.gurosh.com/merchant/orders',
                [
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false,
                    'form_params' => [
                         "store_id" => $store_id,
                         "amount" => $amount,
                         "currency" => $currency,
                         "order_id" => $order_id,
                         "server_url" => $server_url,
                         "success_url" => $success_url,
                         "fail_url" => $fail_url,
                         "signature" => $signature,
                         "details" => $details,
                    ]
                ]
            );
--------------------

//registered users
End Point - Get  - api.sandbox.gurosh.com/regusers
    Main Function -> regusers
    Action     -> list
    $response = $client->request(
                'GET',
                'http://api.sandbox.gurosh.com/reguser',
                [
                    'query' => ['ipn_code' => $ipn_code],
                    'headers' => [
                        'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                    ],
                    'http_errors' => false
                ]
            );


End Point - Post  - api.sandbox.gurosh.com/regusers
    Main Function -> regusers
    Action     -> create
    $response = $client->request(
            'POST',
            'http://api.sandbox.gurosh.com/reguser',
            [
                'headers' => [
                    'Signed-Nonce' => $this->generateAuthSignature($user_data['secret_key'])
                ],
                'http_errors' => false,
                'form_params' => [
                    "ipn_code" => $ipn_code,
                    "asset" => $asset,
                    "surname" => $surname,
                    "name" => $name,
                    "middle_name" => $middle_name,
                    "email" => $email,
                    "phone" => $phone,
                    "address" => $address,
                    "passport" => $passport
                ]
            ]
        );
--------------------

//wallets  nonce not need account type dont checked)
End Point - Get  - api.sandbox.gurosh.com/wallets
    Main Function -> wallets
    Action     -> index


End Point - Get  - api.sandbox.gurosh.com/wallets/getkdf
    Main Function -> wallets
    Action     -> getkdf


End Point - Post  - api.sandbox.gurosh.com/wallets/getparams
    Main Function -> wallets
    Action     -> getparams


End Point - Post  - api.sandbox.gurosh.com/wallets/create
    Main Function -> wallets
    Action     -> create


End Point - Post  - api.sandbox.gurosh.com/wallets/createphone
    Main Function -> wallets
    Action     -> createWithPhone


End Point - Post  - api.sandbox.gurosh.com/wallets/get
    Main Function -> wallets
    Action     -> get


End Point - Post  - api.sandbox.gurosh.com/wallets/update
    Main Function -> wallets
    Action     -> update


End Point - Post  - api.sandbox.gurosh.com/wallets/updatepassword
    Main Function -> wallets
    Action     -> updatePassword


End Point - Post  - api.sandbox.gurosh.com/wallets/notexist
    Main Function -> wallets
    Action     -> notExist


End Point - Post  - api.sandbox.gurosh.com/wallets/getdata
    Main Function -> wallets
    Action     -> getWalletData
--------------------

//sms
End Point - Get  - api.sandbox.gurosh.com/sms/{account_id}
    Main Function -> sms
    Action -> get


End Point - Get  - api.sandbox.gurosh.com/sms/listbyphone/{phone}
    Main Function -> sms
    Action -> listByPhone


End Point - Post  - api.sandbox.gurosh.com/sms
    Main Function -> sms
    Action -> createSms


End Point - Post  - api.sandbox.gurosh.com/sms/submitOTP
    Main Function -> sms
    Action -> submitOTP


End Point - Post  - api.sandbox.gurosh.com/sms/resend
    Main Function -> sms
    Action -> resend


End Point - Post  - api.sandbox.gurosh.com/sms/check
    Main Function -> sms
    Action -> check
