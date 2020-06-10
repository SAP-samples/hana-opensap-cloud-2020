using {cuid} from '@sap/cds/common';

namespace![UserData];

entity![User] : cuid {
    ![FirstName] : String(40);
    ![LastName]  : String(40);
    ![Email]     : String(255);
}

annotate![User] with @(
    title       : '{i18n>userService}',
    description : '{i18n>userService}'
) {
    ID          @(
        title       : '{i18n>user_id}',
        description : '{i18n>user_id}',
    );
    ![FirstName]@title : '{i18n>fname}';
    ![LastName] @title : '{i18n>lname}';
    ![Email]    @title : '{i18n>email}'  @assert.format : '[\\w|-]+@\\w[\\w|-]*\\.[a-z]{2,3}';
};
