class KeysController < ApplicationController

  # top notch security here
  KEY = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA2yAvLaeOudwzbf4Gkl6x2dheb/onCzD+TsGOiEgdPf1cjX4w\nGLZ5ul5JBRrrLH2YrrLUMnVLOvQlhcdA8xXcUSKluSNgP3R8l6dndyYF6sb5VHKq\npZ61ucJ3VTNNz21o0rnkcpcv4dsCGDL5LTih3QCJ8Y/Z7PSJgB/bSE/lnc+rWpti\ng0x2xDR1PXM0nL+9q0XvhTMP2vfpeFqmkDy/wSM/t0LkFqgD97CRMZDboo57/PjO\njqGsgT2j7yn9IgjA4BzqklJg5vjAjAfe1GVw7CbBUUVwkT9iCYfNU31oVKD+0/1v\nyn2jbAmB/Ua1rxw5dRzwY1NTsSuN3oAlNjcLrwIDAQABAoIBAC9HFmbHTCgVtpL4\nx/o0rDLQWC/YzSvA+l2LrXEB/i0tyRZOL5plZIYtaZvMXwlOX+7xbo8kd4LUwnPG\nteC8yrhGvXLgixelzmv6FnzCm2w4Wfs6ck8hmxvlNVIQq60hcghlS0DeFdqpIh6O\ngOyc12+Tei/AVcimSjR2qx1C/8u4aIJY+18KUhkWrwomfk3EIb7eWAfb2M8mHqFT\nD0SixllUCE9DPB6105iiJtCnO+AFGKLY1Rv6PcrMtegmrro3T2egxKjeuOixTiM/\nO7osEPKMERD6r5DR5WTvMbnw22TomhyyQS8iyGN4VIMoObCl8Ip/Ory0a9t/LTfN\ngtJflcECgYEA9KbBRPRCWW3BPUlAmWVIGzP0OJxtZHgkh1SqACkkS9NUpkgWC4Oa\naxgCP7YSVACdW2ZAhbCRTY5q0tNCadMDa6QGfgoPZT60j1ZeSUKAt5YD7h3YcLmc\n1qb4ojy2IU5fEDQ+hyuY9u7oEOP4x+n6NRQ3Zv6kuHedNedU4nXbF4cCgYEA5UpP\nnq5LMsjI9b+FhHj2TcEcuVTlO19ed6hnImOVGo/7Uw5cEvsn6nHvXDjU/PbfFUre\n9P3wnpXv/R+7a5tiuUOdsmL6K4lgPUslXcg2EOpuXVtVPHc4HxFeBTGGzPeOfxNk\nR2Q8F3uYyb+jAWEzqm02QtvTdQ/JtsevcyERJJkCgYEAwJzs+qnH9vp3MhYS+vIH\ndAtSUqOtaHVCZR2d/iRmBCCsu4Fzgbsp/vjXBGwHQAV/3e7CC784lrPynGthFUnh\nnoRz7BVli5NzuooID2uBRYihLX5n4k/wD/tDMw/TYKOAKpTHScpkUr1DDdE+E769\nk76H49nFu8nIhyDK7sRVKs8CgYEAhJPRMclJxdV/DUluZEik8hSFDUxfN1NPhhSj\nfaji3/b8tOuKpZb/X3n9ku9xh8se9mrSPApRBQFhQJUGg5PXI5RLLIg6as4GDarT\nskQ/rsw+gFB9Gnc8xgn+uTYH4aAKjsOhqf31GQboM09Ra0zO2O5I/6OnwvocAkm3\n0vP9u5ECgYEAy51LTE28AJlxtAkkbXc/fRvJJ/Eq1Sv9QBGyUYQfll7d3MNVlyD1\nhFtP1kTy3lp013d/PDhVSh8p4QCcIk1ccmjzyRdpy86r/mHvPYyS8OUnggLHAmnW\nfa0v1kynvdyQ1znV4jDXi2YALK8IrNnxQpgTZHZY7q8DqTeyG5utJLg=\n-----END RSA PRIVATE KEY-----\n"
  USER_ID = ""

  # render JWKS
  def index
    # Generating JWK
    kid = Digest::SHA256.hexdigest(private_key.to_s)
    desc_params = { use: 'sig', alg: 'RS256', kid: kid }
    jwk = JWT::JWK.new(private_key, desc_params)

    #Generating JWKS
    jwks = JWT::JWK::Set.new(jwk).export

    render json: jwks, status: 200
  end

  # fetch JWT
  def show
    kid = Digest::SHA256.hexdigest(private_key.to_s)
    iat = Time.now
    exp =  iat + 59.minutes
    subject = USER_ID
    aud = "https://65a8f82ce4d47fade98f24dd.powersync.journeyapps.com"
    issuer = "https://gotofun-backend.fly.dev"
    token_payload = { exp: exp.to_i, iat: iat.to_i, sub: subject, aud: aud, kid: kid, iss: issuer}
    jwt = JWT.encode(token_payload, private_key, 'RS256', { typ: 'JWT', kid: kid })

    render plain: jwt, status: 200
  end

  private

  def private_key
    OpenSSL::PKey::RSA.new(KEY)
  end
end
