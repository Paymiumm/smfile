parse_amount = api.parse()
parse_amount.add_argument('amount', type=str, required=True, help='amount must be inputted')



class Qrcode(Resource):

    @api.doc(responses={
        'success': 201,
        'validation failed': 401
    })
    def post(self):

        request_details = parse_amount.parse_args()

         if 'user' in session:
            try:
                from app.models import GenerateQrCode
                import random

                qrcode = GenerateQrCode

                qrcode.name = session['user']

                qrcode.transact_id = str(random.random())[2:10]

                qrcode.transact_key = str(random.random())[3:10]

                qrcode.amount = GenerateQrCode(tokens=request_details.get('amount'))

                save_data = str(qrcode.name) + str(qrcode.transact_id) + str(qrcode.transact_key) + str(qrcode.amount)

                save_data.encode('utf-8')

                token = qrcode.generate_hash_token(save_data)

                db.session.add(token)
                db.session.commit()

                hashed_values = base64.b64encode(token)

                return json_response(res=hashed_values, text='success', status_=200)

            except Exception as e:
                return json_response(res='Falied', status_=401)
