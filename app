class GenerateQrcode(Resource):

    def post(self):
        user = params.parse_args()

        get_name = user.get(session['user'])
        get_transact_id = user.get('transact_id')
        get_amount = user.get('amount')
        get_datetime= user.get(datetime.datetime.utcnow())

        user_details = GenerateQrcode(name=get_name, transact_key=get_transact_id, date_time=get_datetime,
                                          amount=get_amount)

        db.session.add(user_details)
        db.session.commit()


        encode_values = user_details.transact_key.encode('utf-8')

        convert_id = base64.b64encode(encode_values)


        session['user'] =  convert_id

        if 'user' in session:

            url = pyqrcode.create(convert_id, error='H', version=20, mode='binary')
