# frozen_string_literal: true

RSpec.describe Freee::Api::Token do
  subject do
    described_class.new('dummy_client_id', 'dummy_client_secret')
  end

  describe '#initialize' do
    it 'assigns id and secret' do
      expect(subject.client.id).to eq('dummy_client_id')
      expect(subject.client.secret).to eq('dummy_client_secret')
    end
    it 'assigns site from the options hash' do
      expect(subject.client.site).to eq('https://api.freee.co.jp')
    end
    it 'assigns authorize_uri from the options hash' do
      expect(subject.client.authorize_url).to eq('https://secure.freee.co.jp/oauth/authorize')
    end
    it 'assigns token_uri from the options hash' do
      expect(subject.client.token_url).to eq('https://api.freee.co.jp/oauth/token')
    end
  end

  describe '#development_authorize' do
    it 'assigns development url' do
      expect(subject.development_authorize).to eq('https://secure.freee.co.jp/oauth/authorize?client_id=dummy_client_id&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code')
    end
  end

  describe '#authorize' do
    context '本番環境用の認証用コードを設定する' do
      it '成功' do
        expect(subject.authorize('localhost')).to eq('https://secure.freee.co.jp/oauth/authorize?client_id=dummy_client_id&redirect_uri=localhost&response_type=code')
      end
      it '失敗' do
        expect{subject.authorize('')}.to raise_error(RuntimeError, '認証用コードを返すためのリダイレクトURLが指定されていません')
      end
    end
  end

  describe '#get_access_token' do
    context 'アクセストークンを取得する' do
      it '必要なパラメータが不足' do
        expect{subject.get_access_token('', 'localhost')}.to raise_error(RuntimeError, '認証用コードが存在しません')
        expect{subject.get_access_token('code', '')}.to raise_error(RuntimeError, 'アクセストークンを返すためのリダイレクトURLが指定されていません')
      end
    end
  end
end