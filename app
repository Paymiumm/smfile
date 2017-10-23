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

                qrcode = GenerateQrCode(name=session['user'], transact_id=str(random.random()[2:10]), transact_key=str(random.random()[3:10]),
                                        time_stamp=datetime.datetime.utcnow(), amount=request_details.get('amount'))

                qrcode.encode('utf-8')

                db.session.add(qrcode)
                db.session.commit()

                hashed_values = base64.b64encode(qrcode)

                return json_response(res=hashed_values, text='success', status_=200)

            except Exception as e:
                return json_response(res='Falied', status_=401)
